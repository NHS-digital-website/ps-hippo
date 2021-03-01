package uk.nhs.digital.apispecs.module;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.mockStatic;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.onehippo.cms7.services.HippoServiceRegistry;
import org.onehippo.repository.mock.MockNode;
import org.onehippo.repository.scheduling.RepositoryJobCronTrigger;
import org.onehippo.repository.scheduling.RepositoryJobInfo;
import org.onehippo.repository.scheduling.RepositoryJobTrigger;
import org.onehippo.repository.scheduling.RepositoryScheduler;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import uk.nhs.digital.apispecs.jobs.ApiSpecRerenderJob;
import uk.nhs.digital.apispecs.jobs.ApiSpecSyncFromApigeeJob;

import java.util.List;
import javax.jcr.Node;
import javax.jcr.RepositoryException;

@RunWith(PowerMockRunner.class)
@PrepareForTest({HippoServiceRegistry.class, ApiSpecSyncFromApigeeModule.class})
public class ApiSpecSyncFromApigeeModuleTest {

    public static final String DAILY_JOB_NAME = "apiSpecSyncFromApigee";
    public static final String NIGHTLY_JOB_NAME = "apiSpecRerender";
    public static final String JOB_GROUP_NAME = "devzone";
    private static final String TRIGGER_NAME = "cronTrigger";

    @Mock private RepositoryScheduler scheduler;

    private ArgumentCaptor<RepositoryJobInfo> jobInfoArgCaptor = ArgumentCaptor.forClass(RepositoryJobInfo.class);
    private ArgumentCaptor<RepositoryJobTrigger> jobTriggerArgCaptor = ArgumentCaptor.forClass(RepositoryJobTrigger.class);

    private Node moduleConfigNode;

    private final ApiSpecSyncFromApigeeModule apiSpecSyncFromApigeeModule = new ApiSpecSyncFromApigeeModule();

    @Before
    public void setUp() {
        initMocks(this);

        moduleConfigNode = new MockNode("api-specification-sync", "hippo:moduleconfig");

        mockStatic(HippoServiceRegistry.class);
        given(HippoServiceRegistry.getService(RepositoryScheduler.class)).willReturn(scheduler);
    }

    @Test
    public void doConfigure_schedulesNewJob_whenConfiguredAsEnabledAndWithCronExpression() throws RepositoryException {

        // given
        final String expectedCronExpression = "0 0/5 * ? * *";

        moduleConfigNode.setProperty("enabled", true);
        moduleConfigNode.setProperty("cronExpression", expectedCronExpression);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(times(2)).scheduleJob(
            jobInfoArgCaptor.capture(),
            jobTriggerArgCaptor.capture()
        );

        final List<RepositoryJobInfo> actualJobInfos = jobInfoArgCaptor.getAllValues();
        final RepositoryJobInfo dailyJobInfo = actualJobInfos.get(0);
        final RepositoryJobInfo nightlyJobInfo = actualJobInfos.get(1);
        assertThat("Job is scheduled with correct group.", dailyJobInfo.getGroup(), is(JOB_GROUP_NAME));
        assertThat("Job is scheduled with correct name.", dailyJobInfo.getName(), is(DAILY_JOB_NAME));
        assertThat("Job is scheduled with correct class.", dailyJobInfo.getJobClass(), is(ApiSpecSyncFromApigeeJob.class));

        assertThat("Job is scheduled with correct group.", nightlyJobInfo.getGroup(), is(JOB_GROUP_NAME));
        assertThat("Job is scheduled with correct name.", nightlyJobInfo.getName(), is(NIGHTLY_JOB_NAME));
        assertThat("Job is scheduled with correct class.", nightlyJobInfo.getJobClass(), is(ApiSpecRerenderJob.class));

        final List<RepositoryJobTrigger> actualJobTriggers = jobTriggerArgCaptor.getAllValues();
        final RepositoryJobTrigger dailyJobTrigger = actualJobTriggers.get(0);
        assertThat("Job is scheduled as a cron job.", dailyJobTrigger, instanceOf(RepositoryJobCronTrigger.class));
        assertThat("Job is scheduled with correct trigger name", dailyJobTrigger.getName(), is(TRIGGER_NAME));
        assertThat("Job is scheduled with correct cron expression", ((RepositoryJobCronTrigger)dailyJobTrigger).getCronExpression(), is(expectedCronExpression));
    }

    @Test
    public void doConfigure_deactivatesOldJob_whenPreviousJobInstanceExists() throws RepositoryException {

        // given
        given(scheduler.checkExists(any(), any())).willReturn(true);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should().checkExists(DAILY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().deleteJob(DAILY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().checkExists(NIGHTLY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().deleteJob(NIGHTLY_JOB_NAME, JOB_GROUP_NAME);
    }

    @Test
    public void doConfigure_doesNotScheduleJob_whenCronExpressionNotSet() throws RepositoryException {

        // given
        mockStatic(System.class);

        moduleConfigNode.setProperty("cronExpression", (String) null);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(never()).scheduleJob(any(), any());
    }

    @Test
    public void doConfigure_schedulesJob_whenCronExpressionSet() throws RepositoryException {

        // given
        mockStatic(System.class);

        moduleConfigNode.setProperty("cronExpression", "0 0/5 * ? * *");

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(times(2)).scheduleJob(any(), any());
    }

    @Test
    public void doConfigure_usesCronExpressionStatusFromJcrOverSystemProperty_whenBothSet() throws RepositoryException {

        // given
        final String cronExpressionFromSystemProperty = "0 0/1 * ? * *";
        final String cronExpressionFromJcr = "0 0/5 * ? * *";

        mockStatic(System.class);
        given(System.getProperty("devzone.apispec.sync.cron-expression")).willReturn(cronExpressionFromSystemProperty);

        moduleConfigNode.setProperty("cronExpression", cronExpressionFromJcr);

        moduleConfigNode.setProperty("enabled", true);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(times(2)).scheduleJob(
            any(),
            jobTriggerArgCaptor.capture()
        );

        final String actualCronExpression = ((RepositoryJobCronTrigger) jobTriggerArgCaptor.getAllValues().get(0)).getCronExpression();

        assertThat(
            "Job is scheduled with cron expression from JCR",
            actualCronExpression,
            is(cronExpressionFromJcr)
        );
    }

    @Test
    public void doConfigure_usesCronExpressionFromSystemPropertyIfAbsentInJcr() throws RepositoryException {

        // given
        final String dailyCronExpressionFromSystemProperty = "0 0/1 * ? * *";
        final String nightlyCronExpressionFromSystemProperty = "0 0/2 * ? * *";

        mockStatic(System.class);
        given(System.getProperty("devzone.apispec.sync.daily-cron-expression")).willReturn(dailyCronExpressionFromSystemProperty);
        given(System.getProperty("devzone.apispec.sync.nightly-cron-expression")).willReturn(nightlyCronExpressionFromSystemProperty);
        // no cron expression property present in JCR

        moduleConfigNode.setProperty("enabled", true);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(times((2))).scheduleJob(
            any(),
            jobTriggerArgCaptor.capture()
        );

        final String actualDailyCronExpression = ((RepositoryJobCronTrigger) jobTriggerArgCaptor.getAllValues().get(0)).getCronExpression();
        final String actualNightlyCronExpression = ((RepositoryJobCronTrigger) jobTriggerArgCaptor.getAllValues().get(1)).getCronExpression();

        assertThat(
            "Job is scheduled with cron expression from system property",
            actualDailyCronExpression,
            is(dailyCronExpressionFromSystemProperty)
        );
        assertThat(
            "Job is scheduled with cron expression from system property",
            actualNightlyCronExpression,
            is(nightlyCronExpressionFromSystemProperty)
        );
    }

    @Test
    public void doShutdown_deletesScheduledJob_whenAMatchingJobPreviouslyScheduled() throws RepositoryException {

        // given
        given(scheduler.checkExists(any(), any())).willReturn(true);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should().checkExists(DAILY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().deleteJob(DAILY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().checkExists(NIGHTLY_JOB_NAME, JOB_GROUP_NAME);
        then(scheduler).should().deleteJob(NIGHTLY_JOB_NAME, JOB_GROUP_NAME);
    }

    @Test
    public void doShutdown_doesNothing_whenNoMatchingJobPreviouslyScheduled() throws RepositoryException {

        // given
        given(scheduler.checkExists(DAILY_JOB_NAME, JOB_GROUP_NAME)).willReturn(false);

        // when
        apiSpecSyncFromApigeeModule.doConfigure(moduleConfigNode);

        // then
        then(scheduler).should(never()).deleteJob(any(), any());
    }
}
