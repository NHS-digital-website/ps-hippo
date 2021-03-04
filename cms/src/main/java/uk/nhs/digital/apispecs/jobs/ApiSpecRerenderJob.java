package uk.nhs.digital.apispecs.jobs;

import org.onehippo.repository.scheduling.RepositoryJob;
import org.onehippo.repository.scheduling.RepositoryJobExecutionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.apispecs.ApiSpecificationPublicationService;
import uk.nhs.digital.apispecs.jcr.ApiSpecificationDocumentJcrRepository;
import uk.nhs.digital.apispecs.swagger.SwaggerCodeGenOpenApiSpecificationJsonToHtmlConverter;

import java.util.Optional;
import javax.jcr.Session;

public class ApiSpecRerenderJob implements RepositoryJob {

    private static final Logger log = LoggerFactory.getLogger(ApiSpecRerenderJob.class);

    @Override
    public void execute(final RepositoryJobExecutionContext context) {

        log.debug("API Specifications refresh: start.");

        Session session = null;

        try {
            session = context.createSystemSession();

            final ApiSpecificationPublicationService apiSpecificationPublicationService =
                new ApiSpecificationPublicationService(
                    null,
                    new ApiSpecificationDocumentJcrRepository(session),
                    new SwaggerCodeGenOpenApiSpecificationJsonToHtmlConverter()
                );

            apiSpecificationPublicationService.rerenderSpecifications();

            log.debug("API Specifications refresh: done.");

        } catch (final Exception ex) {
            log.error("Failed to rerender specifications.", ex);
        } finally {
            Optional.ofNullable(session).ifPresent(Session::logout);
        }
    }
}
