package uk.nhs.digital.apispecs.module;

import org.onehippo.cms7.services.HippoServiceRegistry;
import org.onehippo.repository.modules.AbstractReconfigurableDaemonModule;
import org.onehippo.repository.modules.RequiresService;
import org.onehippo.repository.scheduling.RepositoryJob;
import org.onehippo.repository.scheduling.RepositoryJobCronTrigger;
import org.onehippo.repository.scheduling.RepositoryJobInfo;
import org.onehippo.repository.scheduling.RepositoryScheduler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.JcrNodeUtils;
import uk.nhs.digital.apispecs.jobs.ApiSpecRerenderJob;
import uk.nhs.digital.apispecs.jobs.ApiSpecSyncFromApigeeJob;

import java.util.Arrays;
import java.util.Optional;
import java.util.stream.Stream;
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

@RequiresService(types = { RepositoryScheduler.class } )
public class ApiSpecSyncFromApigeeModule extends AbstractReconfigurableDaemonModule {

    private static final Logger log = LoggerFactory.getLogger(ApiSpecSyncFromApigeeModule.class);

    private final Object configurationLock = new Object();

    private static final String JOB_GROUP = "devzone";
    private static final String JOB_TRIGGER_NAME = "cronTrigger";

    @Override protected void doConfigure(final Node moduleConfigNode) {

        // This method is called both on system startup AND on update to the node through the admin console.
        //
        // Given that we need to update the job on both events, we create and configure the
        // job here rather than in doInitialize which is only being called on system startup.

        synchronized (configurationLock) {
            for (final ScheduledJobs job: ScheduledJobs.values()) {
                try {
                    log.info("Configuring job {}/{} for updating API specifications.", JOB_GROUP, job.jobName); // the only one called on the config node change

                    deactivatePreviousJobInstanceIfExist(job.jobName);

                    if (jobShouldBeEnabled(moduleConfigNode, job)) {

                        scheduleNewJob(moduleConfigNode, job);

                    } else {
                        log.warn("Job {}/{} is not configured to be enabled, therefore it will not be activated.", JOB_GROUP, job.jobName);
                    }

                } catch (final Exception e) {
                    throw new RuntimeException(String.format("Failed to configure job %s/%s", JOB_GROUP, job.jobName), e);
                }
            }
        }
    }

    @Override protected void doInitialize(final Session session) {
        // no-op: all the work is done in doConfigure - see the comment in that method
    }

    @Override protected void doShutdown() {
        Arrays.stream(ScheduledJobs.values())
            .map(x -> x.jobName)
            .forEach(jobName -> {
                try {
                    deactivatePreviousJobInstanceIfExist(jobName);
                } catch (final Exception e) {
                    throw new RuntimeException(String.format("Failed to cleanly shut down job %s/%s", JOB_GROUP, jobName), e);
                }
            });
    }

    private void scheduleNewJob(
        final Node moduleConfigNode,
        final ScheduledJobs job
    ) throws RepositoryException {

        final RepositoryJobInfo jobInfo = new RepositoryJobInfo(job.jobName, JOB_GROUP, job.jobClass);

        final String cronExpression = cronExpression(moduleConfigNode, job);

        final RepositoryJobCronTrigger trigger = new RepositoryJobCronTrigger(JOB_TRIGGER_NAME, cronExpression);

        scheduler().scheduleJob(jobInfo, trigger);

        log.info("Job {}/{} has been scheduled with cron expression: {}", JOB_GROUP, job.jobName, cronExpression);
    }

    private void deactivatePreviousJobInstanceIfExist(final String jobName) throws RepositoryException {
        if (scheduler().checkExists(jobName, JOB_GROUP)) {
            scheduler().deleteJob(jobName, JOB_GROUP);
            log.info("Job {}/{} has been deactivated.", JOB_GROUP, jobName);
        }
    }

    private RepositoryScheduler scheduler() {
        return HippoServiceRegistry.getService(RepositoryScheduler.class);
    }

    private boolean jobShouldBeEnabled(final Node moduleConfigNode, final ScheduledJobs job) {

        final Optional<String> cronExprFromJcr = JcrNodeUtils.getStringPropertyQuietly(moduleConfigNode, job.jcrPropertyName);

        final Optional<String> cronExprFromSystemProperty = Optional.ofNullable(System.getProperty(job.systemPropertyName));

        return Stream.of(cronExprFromJcr, cronExprFromSystemProperty).anyMatch(Optional::isPresent);
    }

    private String cronExpression(final Node moduleConfigNode, final ScheduledJobs job) {

        final Optional<String> cronExprFromJcr = JcrNodeUtils.getStringPropertyQuietly(moduleConfigNode, job.jcrPropertyName);

        final Optional<String> cronExprFromSystemProperty = Optional.ofNullable(System.getProperty(job.systemPropertyName));

        return Stream.of(cronExprFromJcr, cronExprFromSystemProperty)
            .filter(Optional::isPresent)
            .map(Optional::get)
            .findFirst()
            .orElseThrow(() -> new RuntimeException("Cron expression has not been configured."));
    }

    enum ScheduledJobs {

        DAILY(
            "apiSpecSyncFromApigee",
            ApiSpecSyncFromApigeeJob.class,
            "devzone.apispec.sync.daily-cron-expression",
            "cronExpression"
        ),
        NIGHTLY(
            "apiSpecRerender",
            ApiSpecRerenderJob.class,
            "devzone.apispec.sync.nightly-cron-expression",
            "cronExpression"
        );

        private final String jobName;
        private final Class<? extends RepositoryJob> jobClass;
        private final String systemPropertyName;
        private final String jcrPropertyName;

        ScheduledJobs(final String jobName, final Class<? extends RepositoryJob> jobClass, final String systemPropertyName, final String jcrPropertyName) {
            this.jobName = jobName;
            this.jobClass = jobClass;
            this.systemPropertyName = systemPropertyName;
            this.jcrPropertyName = jcrPropertyName;
        }
    }
}
