package uk.nhs.digital.apispecs.apigee;

import static java.util.Collections.unmodifiableList;
import static java.util.stream.Collectors.toList;

import org.onehippo.cms7.crisp.api.broker.ResourceServiceBroker;
import org.onehippo.cms7.crisp.api.resource.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.UriComponentsBuilder;
import uk.nhs.digital.apispecs.OpenApiSpecificationRepository;
import uk.nhs.digital.apispecs.OpenApiSpecificationRepositoryException;
import uk.nhs.digital.apispecs.model.OpenApiSpecificationStatus;

import java.text.MessageFormat;
import java.util.List;
import java.util.function.Supplier;

public class ApigeeService implements OpenApiSpecificationRepository {

    private static final Logger log = LoggerFactory.getLogger(ApigeeService.class);

    private static final String RESOURCE_NAMESPACE_APIGEE_MANAGEMENT_API = "apigeeManagementApi";

    private final ResourceServiceBroker resourceServiceBroker;
    private final String allSpecUrl;
    private final String singleSpecUrl;

    public ApigeeService(final ResourceServiceBroker resourceServiceBroker,
                         final String allSpecUrl,
                         final String singleSpecUrl
    ) {
        this.resourceServiceBroker = resourceServiceBroker;
        this.allSpecUrl = allSpecUrl;
        this.singleSpecUrl = singleSpecUrl;
    }

    @Override
    public List<OpenApiSpecificationStatus> apiSpecificationStatuses() throws OpenApiSpecificationRepositoryException {

        log.debug("Retrieving list of available specifications.");

        return throwServiceExceptionOnFailure(() -> {

                final Resource resource = resourceAt(allSpecUrl);

                return apigeeApiSpecificationsStatusesFrom(resource);
            },
            "Failed to retrieve list of available specifications."
        );
    }

    @Override
    public String apiSpecificationJsonForSpecId(final String specificationId) throws OpenApiSpecificationRepositoryException {

        log.debug("Retrieving specification with id {}.", specificationId);

        return throwServiceExceptionOnFailure(() -> {

                final String singleSpecUrl = urlForSingleSpecification(specificationId);

                final Resource resource = resourceAt(singleSpecUrl);

                return apigeeApiSpecificationJsonFrom(resource);

            },
            "Failed to retrieve specification with id {0}.", specificationId
        );
    }

    private String urlForSingleSpecification(final String specificationId) {
        return UriComponentsBuilder.fromHttpUrl(singleSpecUrl).build(specificationId).toString();
    }

    private Resource resourceAt(final String url) {
        return resourceServiceBroker.resolve(RESOURCE_NAMESPACE_APIGEE_MANAGEMENT_API, url);
    }

    private List<OpenApiSpecificationStatus> apigeeApiSpecificationsStatusesFrom(final Resource resource) {
        final List<OpenApiSpecificationStatus> openApiSpecificationStatuses = unmodifiableList(
            resourceServiceBroker
                .getResourceBeanMapper(RESOURCE_NAMESPACE_APIGEE_MANAGEMENT_API)
                .map(resource, ApigeeSpecificationsStatuses.class)
                .getContents()
                .stream()
                    .map(openApiSpecificationStatus -> {
                        openApiSpecificationStatus.setApigeeService(this);
                        return openApiSpecificationStatus;
                    })
                .collect(toList())
        );

        log.debug("Found {} specifications.", openApiSpecificationStatuses.size());

        return openApiSpecificationStatuses;
    }

    private String apigeeApiSpecificationJsonFrom(final Resource resource) {
        return resource.getNodeData().toString();
    }

    private <T> T throwServiceExceptionOnFailure(
        final Supplier<T> supplier,
        final String errorMessage,
        final Object... errorMessageArgs
    ) {
        try {
            return supplier.get();
        } catch (final Exception cause) {

            final String formattedErrorMessage = MessageFormat.format(
                errorMessage,
                errorMessageArgs
            );

            throw new OpenApiSpecificationRepositoryException(formattedErrorMessage, cause);
        }
    }
}
