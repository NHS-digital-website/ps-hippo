package uk.nhs.digital.apispecs;

import static java.lang.String.format;
import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;
import static uk.nhs.digital.apispecs.ApiSpecificationPublicationService.PublicationResult.*;

import com.google.common.collect.Maps;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.apispecs.model.ApiSpecificationDocument;
import uk.nhs.digital.apispecs.model.OpenApiSpecificationStatus;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

public class ApiSpecificationPublicationService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ApiSpecificationPublicationService.class);

    private OpenApiSpecificationJsonToHtmlConverter openApiSpecificationJsonToHtmlConverter;
    private OpenApiSpecificationRepository openApiSpecificationRepository;
    private ApiSpecificationDocumentRepository apiSpecificationDocumentRepository;

    public ApiSpecificationPublicationService(final OpenApiSpecificationRepository openApiSpecificationRepository,
                                              final ApiSpecificationDocumentRepository apiSpecificationDocumentRepository,
                                              final OpenApiSpecificationJsonToHtmlConverter openApiSpecificationJsonToHtmlConverter) {
        this.openApiSpecificationRepository = openApiSpecificationRepository;
        this.apiSpecificationDocumentRepository = apiSpecificationDocumentRepository;
        this.openApiSpecificationJsonToHtmlConverter = openApiSpecificationJsonToHtmlConverter;
    }

    public void updateAndPublishEligibleSpecifications() {

        final List<ApiSpecificationDocument> cmsApiSpecificationDocuments = findCmsApiSpecifications();

        final List<OpenApiSpecificationStatus> apigeeSpecsStatuses = cmsApiSpecificationDocuments.isEmpty()
            ? emptyList()
            : getApigeeSpecStatuses();

        final List<ApiSpecificationDocument> specsEligibleToUpdateAndPublish = identifySpecsEligibleForUpdateAndPublication(
            cmsApiSpecificationDocuments,
            apigeeSpecsStatuses
        );

        reportNumbersOfSpecsFound(cmsApiSpecificationDocuments, apigeeSpecsStatuses, specsEligibleToUpdateAndPublish);

        updateAndPublish(specsEligibleToUpdateAndPublish);
    }

    public void rerenderSpecifications() {
        LOGGER.info("Rerendering API Specifications in CMS");
        final List<ApiSpecificationDocument> cmsApiSpecificationDocuments = findCmsApiSpecifications();
        LOGGER.info("API Specifications found in CMS: {}", cmsApiSpecificationDocuments.size());
        rerender(cmsApiSpecificationDocuments);
    }

    private void reportNumbersOfSpecsFound(final List<ApiSpecificationDocument> cmsApiSpecificationDocuments,
                                           final List<OpenApiSpecificationStatus> apigeeSpecsStatuses,
                                           final List<ApiSpecificationDocument> specsEligibleToUpdateAndPublish) {

        LOGGER.info(
            "API Specifications found: in CMS: {}, in Apigee: {}, updated in Apigee and eligible to publish in CMS: {}",
            cmsApiSpecificationDocuments.size(),
            cmsApiSpecificationDocuments.isEmpty() ? "not checked" : apigeeSpecsStatuses.size(),
            specsEligibleToUpdateAndPublish.size());
    }

    private List<OpenApiSpecificationStatus> getApigeeSpecStatuses() {
        return openApiSpecificationRepository.apiSpecificationStatuses();
    }

    private List<ApiSpecificationDocument> findCmsApiSpecifications() {
        return apiSpecificationDocumentRepository.findAllApiSpecifications();
    }

    private List<ApiSpecificationDocument> identifySpecsEligibleForUpdateAndPublication(
        final List<ApiSpecificationDocument> cmsSpecs,
        final List<OpenApiSpecificationStatus> apigeeSpecStatuses
    ) {
        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById = Maps.uniqueIndex(apigeeSpecStatuses, OpenApiSpecificationStatus::getId);

        return cmsSpecs.stream()
            .filter(specificationsPresentInBothSystems(apigeeSpecsById))
            .filter(specificationsChangedInApigeeAfterPublishedInCms(apigeeSpecsById))
            .collect(toList());
    }

    private Predicate<ApiSpecificationDocument> specificationsChangedInApigeeAfterPublishedInCms(
        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById) {
        return apiSpecification -> {
            final OpenApiSpecificationStatus apigeeSpec = apigeeSpecsById.get(apiSpecification.getId());

            final Instant cmsSpecificationLastPublicationInstant =
                apiSpecification.getLastPublicationInstant().orElse(Instant.EPOCH);

            return apigeeSpec.getModified().isAfter(cmsSpecificationLastPublicationInstant);
        };
    }

    private Predicate<ApiSpecificationDocument> specificationsPresentInBothSystems(
        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById) {
        return apiSpecification -> apigeeSpecsById.containsKey(apiSpecification.getId());
    }

    private void updateAndPublish(final List<ApiSpecificationDocument> specsToPublish) {

        final long failedSpecificationsCount = specsToPublish.stream()
            .map(this::updateAndPublish)
            .filter(PublicationResult::failed)
            .count();

        reportErrorIfAnySpecificationsFailed(failedSpecificationsCount, specsToPublish.size());
    }

    private PublicationResult updateAndPublish(final ApiSpecificationDocument apiSpecificationDocument) {

        try {
            LOGGER.info("Publishing API Specification: {}", apiSpecificationDocument);

            final String openApiSpecJson = getOpenApiSpecJsonFor(apiSpecificationDocument);

            final String specHtml = specHtmlFrom(openApiSpecJson);

            apiSpecificationDocument.setSpecJson(openApiSpecJson);

            apiSpecificationDocument.setHtml(specHtml);

            apiSpecificationDocument.saveAndPublish();

            LOGGER.info("API Specification has been published: {}", apiSpecificationDocument.getId());

            return PASS;

        } catch (final Exception e) {
            LOGGER.error("Failed to publish API Specification: " + apiSpecificationDocument, e);

            return FAIL;
        }
    }

    private void rerender(final List<ApiSpecificationDocument> specsToPublish) {

        final long failedSpecificationsCount = specsToPublish.stream()
            .map(this::rerender)
            .filter(PublicationResult::failed)
            .count();

        reportErrorIfAnySpecificationsFailed(failedSpecificationsCount, specsToPublish.size());
    }

    private PublicationResult rerender(final ApiSpecificationDocument apiSpecificationDocument) {
        try {
            LOGGER.info("Rerendering API Specification: {}", apiSpecificationDocument);

            final String apiSpecJson = apiSpecificationDocument.getSpecJson();
            final String specHtml = apiSpecJson.isEmpty() ? "" : specHtmlFrom(apiSpecJson);

            final String publishedHtml = apiSpecificationDocument.getHtml();
            final boolean specUnchanged = publishedHtml.equals(specHtml);

            if (specUnchanged) {
                LOGGER.info("No changes to API Specification, skipped: {}", apiSpecificationDocument.getId());
                return PASS;
            }

            apiSpecificationDocument.setHtml(specHtml);

            apiSpecificationDocument.saveAndPublish();

            LOGGER.info("API Specification has been published: {}", apiSpecificationDocument.getId());
            return PASS;

        } catch (final Exception e) {
            LOGGER.error("Failed to publish API Specification: " + apiSpecificationDocument, e);

            return FAIL;
        }
    }

    private String specHtmlFrom(final String openApiSpecJson) {
        return openApiSpecificationJsonToHtmlConverter.htmlFrom(openApiSpecJson);
    }

    private String getOpenApiSpecJsonFor(final ApiSpecificationDocument apiSpecificationDocument) {
        return openApiSpecificationRepository.apiSpecificationJsonForSpecId(apiSpecificationDocument.getId());
    }

    private void reportErrorIfAnySpecificationsFailed(final long failedSpecificationsCount,
                                                      final long specificationsToPublishCount
    ) {
        if (failedSpecificationsCount > 0) {
            throw new RuntimeException(
                format("Failed to publish %d out of %d eligible specifications; see preceding logs for details.",
                    failedSpecificationsCount,
                    specificationsToPublishCount
                ));
        }
    }

    enum PublicationResult {
        PASS,
        FAIL;

        public boolean failed() {
            return this == FAIL;
        }

        public boolean passed() {
            return this == PASS;
        }
    }
}
