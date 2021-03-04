package uk.nhs.digital.common.components.apicatalogue;

import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;
import static java.util.stream.Collectors.toList;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.mockito.MockitoAnnotations.initMocks;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Subsection;

import org.hippoecm.hst.container.ModifiableRequestContextProvider;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.core.component.HstParameterInfoProxyFactoryImpl;
import org.hippoecm.hst.core.container.ComponentManager;
import org.hippoecm.hst.mock.core.component.MockHstRequest;
import org.hippoecm.hst.mock.core.component.MockHstResponse;
import org.hippoecm.hst.mock.core.request.MockHstRequestContext;
import org.hippoecm.hst.site.HstServices;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import uk.nhs.digital.website.beans.ComponentList;
import uk.nhs.digital.website.beans.Internallink;

import java.util.Collections;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Stream;

public class ApiCatalogueComponentTest {

    private static final String REQUEST_ATTR_RESULTS = "apiCatalogueLinks";
    private static final String REQUEST_ATTR_FILTERS = "filtersModel";

    private ApiCatalogueComponent apiCatalogueComponent;

    @Mock
    private ComponentManager compManager;

    private MockHstRequestContext mockHstRequestContext;
    private MockHstResponse response;

    @Before
    public void setUp() throws Exception {
        initMocks(this);

        HstServices.setComponentManager(compManager);
        mockHstRequestContext = new MockHstRequestContext();
        mockHstRequestContext.setParameterInfoProxyFactory(new HstParameterInfoProxyFactoryImpl());
        ModifiableRequestContextProvider.set(mockHstRequestContext);

        apiCatalogueComponent = new ApiCatalogueComponent();

        response = getResponse();
    }

    @Test
    public void listsAllDocumentsFromApiCatalogue_whenNoTagsSelected() {

        // Arrange
        final MockHstRequest request = requestWithFilters(null);

        // Act
        apiCatalogueComponent.doBeforeRender(request, response);

        // Assert
        List<?> actualResults = (List<?>) request.getAttribute(REQUEST_ATTR_RESULTS);

        assertEquals(3, actualResults.size());

        Filters filters = (Filters) request.getAttribute(REQUEST_ATTR_FILTERS);

        List<String> usedTags = getSectionTagsByCondition(filters, Subsection::isSelectable);
        assertEquals(usedTags, asList("dental-health", "mental-health", "fhir", "hl7-v3"));

        List<String> activeTags = getSectionTagsByCondition(filters, Subsection::isSelected);
        assertTrue(activeTags.isEmpty());
    }

    @Test
    public void listsDocumentsApiCatalogueOnlyWithSelectedTags_whenTagSelected() {

        // Arrange
        final MockHstRequest request = requestWithFilters("dental-health");

        // Act
        apiCatalogueComponent.doBeforeRender(request, response);

        // Assert
        List<?> actualResults = (List<?>) request.getAttribute(REQUEST_ATTR_RESULTS);
        assertEquals(1, actualResults.size());

        Filters filters = (Filters) request.getAttribute(REQUEST_ATTR_FILTERS);
        List<String> usedTags = getSectionTagsByCondition(filters, Subsection::isSelectable);
        assertEquals(usedTags, singletonList("dental-health"));

        List<String> activeTags = getSectionTagsByCondition(filters, Subsection::isSelected);
        assertEquals(activeTags, singletonList("dental-health"));
    }

    private MockHstRequest requestWithFilters(final String filterValue) {
        final MockHstRequest request = getRequest();
        request.addParameter("filters", filterValue);

        return request;
    }

    private MockHstRequest getRequest() {
        MockHstRequest hstRequest = new MockHstRequest();
        ComponentList linkList = mock(ComponentList.class);
        List links = asList(
            getLinkWithTaxonomyKeys("dental-health"),
            getLinkWithTaxonomyKeys("mental-health"),
            getLinkWithTaxonomyKeys("fhir", "hl7-v3")
        );
        given(linkList.getBlocks()).willReturn(links);
        mockHstRequestContext.setContentBean(linkList);
        hstRequest.setRequestContext(mockHstRequestContext);
        return hstRequest;
    }

    private Internallink getLinkWithTaxonomyKeys(String... taxonomyKeys) {
        Internallink link = mock(Internallink.class);
        HippoBean bean = mock(HippoBean.class);
        given(link.getLinkType()).willReturn("internal");
        given(link.getLink()).willReturn(bean);
        given(bean.getProperties()).willReturn(Collections.singletonMap("hippotaxonomy:keys", taxonomyKeys));
        return link;
    }

    private List<String> getSectionTagsByCondition(final Filters filters, final Predicate<Subsection> predicate) {
        return subsectionsStreamFrom(filters)
            .filter(predicate)
            .map(Subsection::getTaxonomyKey)
            .collect(toList());
    }

    private MockHstResponse getResponse() {
        return new MockHstResponse();
    }

    private static Stream<Subsection> subsectionsStreamFrom(final Filters model) {
        return model.getSections().stream()
            .flatMap(section -> section.getEntries().stream());
    }
}
