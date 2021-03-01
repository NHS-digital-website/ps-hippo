package uk.nhs.digital.apispecs;

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

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
    public void publish_publishesSpecification_thatChangedInApigeeAfterItWasPublishedInCms() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-20T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp);
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecUpdateSincePublished = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecUpdateSincePublished));

        final String specificationJson = "{ \"json\": \"payload\" }";
        when(apigeeService.apiSpecificationJsonForSpecId(specificationId)).thenReturn(specificationJson);

        final String specificationHtml = "<html><body> Some spec content </body></html>";
        when(apiSpecHtmlProvider.htmlFrom(specificationJson)).thenReturn(specificationHtml);

        // when
        apiSpecificationPublicationService.updateAndPublishEligibleSpecifications();

        // then
        then(cmsSpecPublished).should().setSpecJson(specificationJson);
        then(cmsSpecPublished).should().setHtml(specificationHtml);
        then(cmsSpecPublished).should().saveAndPublish();
    }

    @Test
    public void publish_doesNotChangeNorPublishSpecifications_ifTheyHaveNotChangedInApigeeAfterTheyWerePublishedInCms() {

        // given
        final String specificationId = "248569";

        // @formatter:off
        final String lastCmsPublicationTimestamp     = "2020-05-10T10:30:00.000Z";
        final String lastApigeeModificationTimestamp = "2020-05-10T10:30:00.000Z";
        // @formatter:on

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp);
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecNotUpdatedSincePublished = remoteSpecStatus(specificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecNotUpdatedSincePublished));

        // when
        apiSpecificationPublicationService.updateAndPublishEligibleSpecifications();

        // then
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

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(cmsSpecificationId, lastCmsPublicationTimestamp);
        when(apiSpecDocumentRepo.findAllApiSpecifications()).thenReturn(singletonList(cmsSpecPublished));

        final OpenApiSpecificationStatus apigeeSpecUpdateSincePublished = remoteSpecStatus(remoteSpecificationId, lastApigeeModificationTimestamp);
        when(apigeeService.apiSpecificationStatuses()).thenReturn(singletonList(apigeeSpecUpdateSincePublished));

        // when
        apiSpecificationPublicationService.updateAndPublishEligibleSpecifications();

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
        apiSpecificationPublicationService.updateAndPublishEligibleSpecifications();

        // then
        then(apigeeService).shouldHaveZeroInteractions();
    }

    @Test
    public void publish_canHandleMultipleSpecifications() {

        // given
        final String specificationAId = "248569";
        final String specificationBId = "965842";

        final ApiSpecificationDocument cmsSpecAPublished = apiSpecDoc(specificationAId, "2020-05-11T10:30:00.000Z");
        final ApiSpecificationDocument cmsSpecBPublished = apiSpecDoc(specificationBId, "2020-05-10T10:30:00.000Z");
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
        apiSpecificationPublicationService.updateAndPublishEligibleSpecifications();

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

        final ApiSpecificationDocument cmsSpecPublished = apiSpecDoc(specificationId, lastCmsPublicationTimestamp);
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


    private ApiSpecificationDocument apiSpecDoc(final String specificationId, final String lastModTimestamp) {

        final ApiSpecificationDocument apiSpecificationDocument = mock(ApiSpecificationDocument.class);

        given(apiSpecificationDocument.getId()).willReturn(specificationId);
        given(apiSpecificationDocument.getLastPublicationInstant()).willReturn(Optional.of(Instant.parse(lastModTimestamp)));

        return apiSpecificationDocument;
    }

    private OpenApiSpecificationStatus remoteSpecStatus(final String specificationId, final String lastModifiedInstant) {
        return new OpenApiSpecificationStatus(specificationId, lastModifiedInstant);
    }
}
