package uk.nhs.digital.apispecs;

import static java.lang.String.format;
import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;
import static uk.nhs.digital.apispecs.ApiSpecificationPublicationService.PublicationResult.FAIL;
import static uk.nhs.digital.apispecs.ApiSpecificationPublicationService.PublicationResult.PASS;

import com.google.common.collect.Maps;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.apispecs.model.ApiSpecificationDocument;
import uk.nhs.digital.apispecs.model.OpenApiSpecificationStatus;
import uk.nhs.digital.common.util.TimeProvider;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.regex.Pattern;

public class ApiSpecificationPublicationService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ApiSpecificationPublicationService.class);

    private static final Pattern VERSION_FIELD_PATTERN = Pattern.compile("\"version\"\\s*:\\s*\"[^\"]+\"");

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

    public void syncEligibleSpecifications() {

        final List<ApiSpecificationDocument> cmsApiSpecificationDocuments = findCmsApiSpecifications();

        final List<OpenApiSpecificationStatus> apigeeSpecsStatuses = cmsApiSpecificationDocuments.isEmpty()
            ? emptyList()
            : getApigeeSpecStatuses();

        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById = Maps.uniqueIndex(
            apigeeSpecsStatuses, OpenApiSpecificationStatus::getId
        );

        final List<SpecPublicationData> fullyProcessedSpecPublicationData = cmsApiSpecificationDocuments.stream()
            .filter(specificationsPresentInBothSystems(apigeeSpecsById))
            .map(toBasicSpecPublicationData(apigeeSpecsById))
            .map(toSpecPublicationDataWithRenderedHtml())
            .map(toSpecPublicationDataWithUpdatedLastCheckTimestamp())
            .map(toPublishedSpecPublicationData())
            .collect(toList());

        reportPublicationStatusFor(fullyProcessedSpecPublicationData);
    }

    private void reportPublicationStatusFor(final List<SpecPublicationData> specPublicationData) {
        System.out.println(specPublicationData);
    }

    private Function<SpecPublicationData, SpecPublicationData> toPublishedSpecPublicationData() {
        return specPublicationData -> {
            if (specPublicationData.noFailure() && specPublicationData.isSpecContentChanged()) {
                updateAndPublish(specPublicationData);
            }
            return specPublicationData;
        };
    }

    private Function<SpecPublicationData, SpecPublicationData> toSpecPublicationDataWithUpdatedLastCheckTimestamp() {
        return specPublicationData -> {

            if (specPublicationData.noFailure()) {
                try {
                    specPublicationData.localSpec.setLastCheckedTimestamp(TimeProvider.getNowInstant());
                    specPublicationData.localSpec.save();
                } catch (final Exception e) {
                    specPublicationData.setError("Failed to record time of last check.", e);
                }
            }

            return specPublicationData;
        };
    }

    private Function<SpecPublicationData, SpecPublicationData> toSpecPublicationDataWithRenderedHtml() {
        return specPublicationData -> {
            if (specPublicationData.isSpecContentChanged()) {
                try {
                    final String html = openApiSpecificationJsonToHtmlConverter.htmlFrom(
                        specPublicationData.remoteSpec.getSpecJson()
                    );

                    specPublicationData.setHtml(html);

                } catch (final Exception e) {
                    specPublicationData.setError("Failed to render.", e);
                }
            }
            return specPublicationData;
        };
    }

    private Function<ApiSpecificationDocument, SpecPublicationData> toBasicSpecPublicationData(
        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById) {
        return cmsSpec -> SpecPublicationData.with(
            cmsSpec,
            apigeeSpecsById.get(cmsSpec.getId())
        );
    }

    public void rerenderSpecifications() {
        LOGGER.info("Rerendering API Specifications in CMS");
        final List<ApiSpecificationDocument> cmsApiSpecificationDocuments = findCmsApiSpecifications();
        LOGGER.info("API Specifications found in CMS: {}", cmsApiSpecificationDocuments.size());
        rerender(cmsApiSpecificationDocuments);
    }

    // private void reportNumbersOfSpecsFound(final List<ApiSpecificationDocument> cmsApiSpecificationDocuments,
    //                                        final List<OpenApiSpecificationStatus> apigeeSpecsStatuses,
    //                                        final List<ApiSpecificationDocument> specsEligibleToUpdateAndPublish) {
    //
    //     LOGGER.info(
    //         "API Specifications found: in CMS: {}, in Apigee: {}, updated in Apigee and eligible to publish in CMS: {}",
    //         cmsApiSpecificationDocuments.size(),
    //         cmsApiSpecificationDocuments.isEmpty() ? "not checked" : apigeeSpecsStatuses.size(),
    //         specsEligibleToUpdateAndPublish.size());
    // }

    private List<OpenApiSpecificationStatus> getApigeeSpecStatuses() {
        return openApiSpecificationRepository.apiSpecificationStatuses();
    }

    private List<ApiSpecificationDocument> findCmsApiSpecifications() {
        return apiSpecificationDocumentRepository.findAllApiSpecifications();
    }

    private Predicate<ApiSpecificationDocument> specificationsPresentInBothSystems(
        final Map<String, OpenApiSpecificationStatus> apigeeSpecsById) {
        return apiSpecification -> apigeeSpecsById.containsKey(apiSpecification.getId());
    }

    private void updateAndPublish(final SpecPublicationData specPublicationData) {

        try {
            final ApiSpecificationDocument localSpec = specPublicationData.localSpec;

            localSpec.setSpecJson(specPublicationData.remoteSpec.getSpecJson());

            localSpec.setHtml(specPublicationData.html);

            localSpec.saveAndPublish();

            specPublicationData.markPublished();

        } catch (final Exception e) {
            specPublicationData.setError("Failed to publish.", e);
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
        FAIL,
        SKIPPED;

        public boolean failed() {
            return this == FAIL;
        }

        public boolean passed() {
            return this == PASS;
        }
    }

    private static class SpecPublicationData {

        private final ApiSpecificationDocument localSpec;
        private final OpenApiSpecificationStatus remoteSpec;
        private final Instant lastChecked;
        private Boolean specContentChanged;
        private String html;
        private Exception error;
        private boolean published;

        private SpecPublicationData(
            final ApiSpecificationDocument localSpec,
            final OpenApiSpecificationStatus remoteSpec,
            final Instant lastChecked
        ) {
            this.localSpec = localSpec;
            this.remoteSpec = remoteSpec;
            this.lastChecked = lastChecked;
        }

        public static SpecPublicationData with(
            final ApiSpecificationDocument localSpec,
            final OpenApiSpecificationStatus remoteSpec
        ) {
            return new SpecPublicationData(
                localSpec,
                remoteSpec,
                localSpec.getLastCheckedInstant().orElse(Instant.EPOCH)
            );
        }

        public boolean isSpecContentChanged() {

            if (specContentChanged == null) {

                specContentChanged = remoteSpec.getModified().isAfter(localSpecLastCheckInstant())
                    && specContentDiffersIgnoringVersion(
                        remoteSpec.getSpecJson(),
                        localSpec.getSpecJson()
                    );
            }

            return specContentChanged;
        }

        @NotNull private Instant localSpecLastCheckInstant() {
            final Instant cmsSpecificationLastCheckInstant =
                localSpec.getLastCheckedInstant().orElse(Instant.EPOCH);
            return cmsSpecificationLastCheckInstant;
        }

        private static boolean specContentDiffersIgnoringVersion(final String left, final String right) {
            // We're ignoring version field because it often is the only piece of spec's content that actually changes.
            // It is calculated from git tags which are incremented on each merge to master (of the API repo)
            // and that incrementation often takes place as a result of the API itself being updated with no
            // change to the spec itself.

            final String leftSpecJsonNoVersion = VERSION_FIELD_PATTERN.matcher(left).replaceFirst("");
            final String rightSpecJsonNoVersion = VERSION_FIELD_PATTERN.matcher(right).replaceFirst("");

            return !leftSpecJsonNoVersion.equals(rightSpecJsonNoVersion);
        }


        private void setHtml(final String html) {
            this.html = html;
        }

        private void setError(final String message, final Exception cause) {
            this.error = new RuntimeException(message, cause);
        }

        private boolean noFailure() {
            return error == null;
        }

        private void markPublished() {
            published = true;
        }
    }
}
