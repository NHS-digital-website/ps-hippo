package uk.nhs.digital.apispecs;

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;
import static uk.nhs.digital.test.util.TimeProviderTestUtils.fixNowTo;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import uk.nhs.digital.apispecs.jcr.ApiSpecificationDocumentJcrRepository;
import uk.nhs.digital.apispecs.model.ApiSpecificationDocument;
import uk.nhs.digital.apispecs.model.OpenApiSpecificationStatus;

import java.time.Instant;
import java.util.Optional;

@RunWith(MockitoJUnitRunner.class)
public class ApiSpecificationPublicationServiceTest {

    @Mock
    private OpenApiSpecificationRepository apigeeService;

    @Mock
    private ApiSpecificationDocumentJcrRepository apiSpecDocumentRepo;

    @Mock
    private OpenApiSpecificationJsonToHtmlConverter apiSpecHtmlProvider;

    private ApiSpecificationPublicationService apiSpecificationPublicationService;

    @Before
    public void setUp() {
        initMocks(this);

        apiSpecificationPublicationService = new ApiSpecificationPublicationService(
            apigeeService,
            apiSpecDocumentRepo,
            apiSpecHtmlProvider
        );
    }


    @Test
    public void publish_publishesSpecifications_existingInCmsButNeverPublished() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastApigeeModificationTimestamp = "2020-05-20T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, "");
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpec = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpec));

        final String specificationJson = "{ \"json\": \"payload\" }";
        when(apigeeService.apiSpecificationJsonForSpecId(specificationId)).thenReturn(specificationJson);

        final String specificationHtml = "<html><body> Some spec content </body></html>";
        when(apiSpecHtmlProvider.htmlFrom(specificationJson)).thenReturn(specificationHtml);

        final Instant lastCheckTimestamp = fixNowTo("2020-05-10T10:30:00.001Z");

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecPublished).should().setLastCheckedTimestamp(lastCheckTimestamp);
        then(cmsSpecPublished).should().save();

        then(cmsSpecPublished).should().setSpecJson(specificationJson);
        then(cmsSpecPublished).should().setHtml(specificationHtml);
        then(cmsSpecPublished).should().saveAndPublish();
    }

    @Test
    public void publish_publishesSpecifications_thatChangedInApigeeAfterItWasPublishedInCms() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-20T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp, "{\"spec\":\"json\"}");
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecUpdateSincePublished = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecUpdateSincePublished));

        final String specificationJson = "{ \"json\": \"payload\" }";
        when(apigeeService.apiSpecificationJsonForSpecId(specificationId)).thenReturn(specificationJson);

        final String specificationHtml = "<html><body> Some spec content </body></html>";
        when(apiSpecHtmlProvider.htmlFrom(specificationJson)).thenReturn(specificationHtml);

        final Instant lastCheckTimestamp = fixNowTo("2020-05-10T10:30:00.001Z");

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecPublished).should().setLastCheckedTimestamp(lastCheckTimestamp);
        then(cmsSpecPublished).should().save();

        then(cmsSpecPublished).should().setSpecJson(specificationJson);
        then(cmsSpecPublished).should().setHtml(specificationHtml);
        then(cmsSpecPublished).should().saveAndPublish();
    }

    @Test
    public void publish_doesNotChangeNorPublishSpecifications_whereApigeeReportsChangeAfterLastCheckInCms_butApigeeContentHasNotActuallyChanged() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-20T10:30:00.000Z";

        // Specs differ in version only; this field is ignored when comparing specs' JSON for changes.
        final String specJsonCms    = "{ \"info\": {\"version\": \"v1.2.525-beta\"}, \"json\": \"payload\" }";
        final String specJsonApigee = "{ \"info\": {\"version\": \"v1.2.526-beta\"}, \"json\": \"payload\" }";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp, specJsonCms);
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecUpdateSincePublished = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecUpdateSincePublished));

        when(apigeeService.apiSpecificationJsonForSpecId(specificationId)).thenReturn(specJsonApigee);

        final Instant lastCheckTimestamp = fixNowTo("2020-05-10T10:30:00.001Z");

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecPublished).should().setLastCheckedTimestamp(lastCheckTimestamp);
        then(cmsSpecPublished).should().save();

        then(cmsSpecPublished).should(never()).setSpecJson(any());
        then(cmsSpecPublished).should(never()).setHtml(any());
        then(cmsSpecPublished).should(never()).saveAndPublish();
    }

    @Test
    public void publish_doesNotChangeNorPublishSpecifications_ifApigeeReportsNoChangeAfterLastCheckInCms() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-10T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp, "{\"spec\":\"json\"}");
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecNotUpdatedSincePublished = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecNotUpdatedSincePublished));

        final Instant lastCheckTimestamp = fixNowTo("2020-05-10T10:30:00.001Z");

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecPublished).should().setLastCheckedTimestamp(lastCheckTimestamp);
        then(cmsSpecPublished).should().save();

        then(cmsSpecPublished).should(never()).setSpecJson(any());
        then(cmsSpecPublished).should(never()).setHtml(any());
        then(cmsSpecPublished).should(never()).saveAndPublish();
    }

    @Test
    public void publish_doesNotChangeNorPublishSpecifications_ifTheyDoNotHaveMatchingCounterpartsInRemoteSystem() {

        // given
        // @formatter:off
        final String cmsSpecificationId    = "965842";
        final String remoteSpecificationId = "248569";

        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-20T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(cmsSpecificationId, lastCmsPublicationTimestamp, "{\"spec\":\"json\"}");
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecUpdateSincePublished = remoteSpecStatus(remoteSpecificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecUpdateSincePublished));

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecPublished).should(never()).setSpecJson(any());
        then(cmsSpecPublished).should(never()).setHtml(any());
        then(cmsSpecPublished).should(never()).saveAndPublish();
    }

    @Test
    public void publish_doesNotMakeAnyRequestToApigee_ifThereAreNoLocalApiSpecDocuments() {

        // given
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(emptyList());

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(apigeeService).shouldHaveZeroInteractions();
    }

    @Test
    public void publish_canHandleMultipleSpecifications() {

        // given
        final String specificationAId = "248569";
        final String specificationBId = "965842";

        final ApiSpecificationDocument cmsSpecAPublished = apiSpecDoc(specificationAId, "2020-05-11T10:30:00.000Z", "{\"spec\":\"json\"}");
        final ApiSpecificationDocument cmsSpecBPublished = apiSpecDoc(specificationBId, "2020-05-10T10:30:00.000Z", "{\"spec\":\"json\"}");
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(asList(
            cmsSpecAPublished,
            cmsSpecBPublished
        ));

        final OpenApiSpecificationStatus apigeeSpecAUpdateSincePublished = remoteSpecStatus(specificationAId, "2020-05-20T10:30:00.000Z");
        final OpenApiSpecificationStatus apigeeSpecBUpdateSincePublished = remoteSpecStatus(specificationBId, "2020-05-21T10:30:00.000Z");
        when(apigeeService.apiSpecificationStatuses()).thenReturn(asList(
            apigeeSpecAUpdateSincePublished,
            apigeeSpecBUpdateSincePublished
        ));

        final String specificationAJson = "{ \"json\": \"payload A\" }";
        when(apigeeService.apiSpecificationJsonForSpecId(specificationAId)).thenReturn(specificationAJson);
        final String specificationBJson = "{ \"json\": \"payload B\" }";
        when(apigeeService.apiSpecificationJsonForSpecId(specificationBId)).thenReturn(specificationBJson);

        final String specificationAHtml = "<html><body> spec A content </body></html>";
        final String specificationBHtml = "<html><body> spec B content </body></html>";
        when(apiSpecHtmlProvider.htmlFrom(specificationAJson)).thenReturn(specificationAHtml);
        when(apiSpecHtmlProvider.htmlFrom(specificationBJson)).thenReturn(specificationBHtml);

        // when
        apiSpecificationPublicationService.syncEligibleSpecifications();

        // then
        then(cmsSpecAPublished).should().setSpecJson(specificationAJson);
        then(cmsSpecAPublished).should().setHtml(specificationAHtml);
        then(cmsSpecAPublished).should().saveAndPublish();

        then(cmsSpecBPublished).should().setSpecJson(specificationBJson);
        then(cmsSpecBPublished).should().setHtml(specificationBHtml);
        then(cmsSpecBPublished).should().saveAndPublish();
    }

    @Test
    public void rerender_skipsSpecificationWhenUnchanged() {
        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp, "{\"spec\":\"json\"}");
        final String cmsSpecificationJson = "{ \"json\": \"payload\" }";
        final String publishedSpecificationHtml = "<html><body> Some spec content </body></html>";

        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));
        when(cmsSpecPublished.getSpecJson()).thenReturn(cmsSpecificationJson);
        when(cmsSpecPublished.getHtml()).thenReturn(publishedSpecificationHtml);
        when(apiSpecHtmlProvider.htmlFrom(cmsSpecificationJson)).thenReturn(publishedSpecificationHtml);

        // when
        apiSpecificationPublicationService.rerenderSpecifications();

        // then
        then(cmsSpecPublished).should().getSpecJson();
        then(cmsSpecPublished).should().getHtml();
        then(cmsSpecPublished).should().getId(); // this call is made for the sake of logging
        then(cmsSpecPublished).shouldHaveNoMoreInteractions();
    }

    @Test
    public void rerender_updatesAndPublishesSpecificationWhenChanged() {

        final ApiSpecificationDocument cmsSpecPublished = mock(ApiSpecificationDocument.class);
        final String cmsSpecificationJson = "{ \"json\": \"payload\" }";
        final String cmsSpecificationHtml = "<html><body> Some spec content </body></html>";

        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));
        when(cmsSpecPublished.getSpecJson()).thenReturn(cmsSpecificationJson);
        when(cmsSpecPublished.getHtml()).thenReturn("<html><body> Some outdated spec content </body></html>");
        when(apiSpecHtmlProvider.htmlFrom(cmsSpecificationJson)).thenReturn(cmsSpecificationHtml);

        // when
        apiSpecificationPublicationService.rerenderSpecifications();

        // then
        then(cmsSpecPublished).should().getSpecJson();
        then(cmsSpecPublished).should().getHtml();
        then(cmsSpecPublished).should().setHtml(cmsSpecificationHtml);
        then(cmsSpecPublished).should().saveAndPublish();
        then(cmsSpecPublished).should().getId(); // this call is made for the sake of logging
        then(cmsSpecPublished).shouldHaveNoMoreInteractions();
    }


    private ApiSpecificationDocument apiSpecDoc(final String specificationId) {
        return apiSpecDoc(specificationId, null, "{\"spec\":\"json\"}");
    }

    private ApiSpecificationDocument apiSpecDoc(final String specificationId, final String json) {
        return apiSpecDoc(specificationId, null, json);
    }

    private ApiSpecificationDocument apiSpecDoc(final String specificationId, final String lastModTimestamp, final String json) {

        final ApiSpecificationDocument apiSpecificationDocument = mock(ApiSpecificationDocument.class);

        given(apiSpecificationDocument.getId()).willReturn(specificationId);

        given(apiSpecificationDocument.getLastCheckedInstant()).willReturn(
            Optional.ofNullable(lastModTimestamp).map(Instant::parse)
        );

        given(apiSpecificationDocument.getSpecJson()).willReturn(json);

        return apiSpecificationDocument;
    }

    private OpenApiSpecificationStatus remoteSpecStatus(final String specificationId, final String lastModifiedInstant) {
        final OpenApiSpecificationStatus openApiSpecificationStatus = new OpenApiSpecificationStatus(specificationId, lastModifiedInstant);
        openApiSpecificationStatus.setApigeeService(apigeeService);

        return openApiSpecificationStatus;
    }
}
