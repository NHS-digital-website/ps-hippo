package uk.nhs.digital.ps.beans;

import static java.util.Arrays.asList;
import static java.util.Arrays.stream;
import static java.util.stream.Collectors.toList;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.MockitoAnnotations.initMocks;
import static uk.nhs.digital.ps.beans.RestrictableDateTest.assertRestrictableDate;

import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;
import org.hippoecm.hst.container.RequestContextProvider;
import org.hippoecm.hst.content.beans.manager.ObjectConverter;
import org.hippoecm.hst.content.beans.query.HstQuery;
import org.hippoecm.hst.content.beans.query.HstQueryResult;
import org.hippoecm.hst.content.beans.query.builder.HstQueryBuilder;
import org.hippoecm.hst.content.beans.standard.HippoFolder;
import org.hippoecm.hst.core.request.HstRequestContext;
import org.hippoecm.hst.mock.core.request.MockHstRequestContext;
import org.hippoecm.hst.provider.jcr.JCRValueProvider;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.modules.junit4.PowerMockRunnerDelegate;
import uk.nhs.digital.ps.site.exceptions.DataRestrictionViolationException;
import uk.nhs.digital.ps.test.util.ReflectionHelper;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import javax.jcr.Node;
import javax.jcr.NodeIterator;


@RunWith(PowerMockRunner.class)
@PowerMockIgnore({"javax.management.*", "javax.script.*"})
@PowerMockRunnerDelegate(DataProviderRunner.class)
@PrepareForTest(HstQueryBuilder.class)
public class PublicationTest {

    private static final String NOMINAL_DATE_PROPERTY_KEY = "publicationsystem:NominalDate";
    private static final String PUBLICLY_ACCESSIBLE_PROPERTY_KEY = "publicationsystem:PubliclyAccessible";
    private static final String ATTACHMENTS_PROPERTY_KEY = "publicationsystem:Attachments-v3";
    private static final String RELATED_LINKS_PROPERTY_KEY = "publicationsystem:RelatedLinks";
    private static final String RESOURCE_LINKS_PROPERTY_KEY = "publicationsystem:ResourceLinks";
    private static final String KEY_FACT_IMAGES_KEY = "publicationsystem:KeyFactImages";
    private static final String KEY_FACT_INFOGRAPHIC_KEY = "website:infographic";
    private static final String KEY_FACT_INFOGRAPHICS = "publicationsystem:keyFactInfographics";
    private static final String HIGHLIGHTS = "publicationsystem:Highlights";
    private static final String INTERACTIVE_TOOL_KEY = "publicationsystem:interactivetool";
    private static final String CHANGE_NOTICE_KEY = "publicationsystem:changenotice";

    @Mock private JCRValueProvider valueProvider;
    @Mock private Node node;
    @Mock private NodeIterator nodeIterator;
    @Mock private ObjectConverter objectConverter;
    @Mock private Node folderNode;
    @Mock private HippoFolder folder;

    @Mock private HstRequestContext requestContext;
    @Mock private HstQueryBuilder queryBuilder;
    @Mock private HstQuery query;
    @Mock private HstQueryResult queryResult;

    private final Map<String, Object> beanProperties = new HashMap<>();
    private Publication publication;
    private Calendar cutOffDate;
    private static final int WEEKS_TO_CUTOFF = 8;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        beanProperties.clear();

        final Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.WEEK_OF_MONTH, WEEKS_TO_CUTOFF);
        cutOffDate = calendar;

        publication = new Publication();

        given(valueProvider.getProperties()).willReturn(beanProperties);
        given(valueProvider.getParentJcrNode()).willReturn(folderNode);

        given(nodeIterator.hasNext()).willReturn(false);
        given(node.getNodes(ATTACHMENTS_PROPERTY_KEY)).willReturn(nodeIterator);
        given(node.getNodes(RELATED_LINKS_PROPERTY_KEY)).willReturn(nodeIterator);
        given(node.getNodes(RESOURCE_LINKS_PROPERTY_KEY)).willReturn(nodeIterator);
        given(node.getNodes(KEY_FACT_IMAGES_KEY)).willReturn(nodeIterator);
        given(node.getNodes(KEY_FACT_INFOGRAPHIC_KEY)).willReturn(nodeIterator);
        given(node.getNodes(KEY_FACT_INFOGRAPHICS)).willReturn(nodeIterator);
        given(node.getNodes(HIGHLIGHTS)).willReturn(nodeIterator);
        given(node.getNodes(INTERACTIVE_TOOL_KEY)).willReturn(nodeIterator);
        given(node.getNodes(CHANGE_NOTICE_KEY)).willReturn(nodeIterator);

        given(objectConverter.getObject(folderNode)).willReturn(folder);
        given(folderNode.getNodes()).willReturn(nodeIterator);
        given(folder.isSelf(any())).willReturn(true); // make it look like the folder is the root folder

        // Mock this static method so we can simulate the building and execution of a query
        PowerMockito.mockStatic(HstQueryBuilder.class);
        PowerMockito.when(HstQueryBuilder.create(folder)).thenReturn(queryBuilder);

        given(queryBuilder.ofTypes(any(Class.class))).willReturn(queryBuilder);
        given(queryBuilder.orderByDescending(anyString())).willReturn(queryBuilder);
        given(queryBuilder.build()).willReturn(query);
        given(query.execute()).willReturn(queryResult);

        ReflectionHelper.callMethod(RequestContextProvider.class, "set", HstRequestContext.class, requestContext);

        ReflectionHelper.setField(publication, "name", "arbitrary-name");
        ReflectionHelper.setField(publication, "valueProvider", valueProvider);
        ReflectionHelper.setField(publication, "node", node);
        ReflectionHelper.setField(publication, "objectConverter", objectConverter);
    }

    // NOTE: usually, with tests involving time, obtaining 'now' value would be facilitated via custom time provider
    // which, mocked in tests, would enable precise control over the value of 'now'. In this case, however, it's
    // easy to manipulate the value of 'Publication Date' - which has to be set anyway - and so, for simplicity
    // reasons, it was decided to not to introduce additional complexity in a form time provider. This will be easy
    // to change should more complex cases arise, however.

    @Test
    public void returnsRestrictedNominalPublicationDate_whenItFallsAfterTheCutOffPoint() throws Exception {

        // given
        final Calendar dayAfterCutOff = (Calendar) cutOffDate.clone();
        dayAfterCutOff.add(Calendar.DAY_OF_MONTH, 1);
        setBeanProperty(NOMINAL_DATE_PROPERTY_KEY, dayAfterCutOff);

        final LocalDate dayAfterCutoffLocalDate = toLocalDate(dayAfterCutOff);

        // when
        final RestrictableDate actualNominalPublicationDate = publication.getNominalPublicationDate();

        // then
        assertRestrictableDate(actualNominalPublicationDate, true, dayAfterCutoffLocalDate);
    }

    @Test
    public void returnsFullNominalPublicationDate_whenIfFallsBeforeTheCutOffPoint() throws Exception {

        // given
        setBeanProperty(NOMINAL_DATE_PROPERTY_KEY, cutOffDate);
        final LocalDate cutOffLocalDate = toLocalDate(cutOffDate);

        // when
        final RestrictableDate actualNominalPublicationDate = publication.getNominalPublicationDate();

        // then
        assertRestrictableDate(actualNominalPublicationDate, false, cutOffLocalDate);
    }

    @Test
    public void returnsNull_whenNoNominalPublicationDateHasBeenSet() throws Exception {

        // given
        // no Publication Date value has been set

        // when
        final RestrictableDate actualNominalPublicationDate = publication.getNominalPublicationDate();

        // then
        assertThat("No value was returned.", actualNominalPublicationDate, is(nullValue()));
    }

    @Test
    @UseDataProvider("gettersForbiddenInUpcomingPublication")
    public void restrictsGetters_whenPublicationNotPubliclyAvailable(
        final Method forbiddenGetter) throws Exception {

        // given
        setBeanProperty(PUBLICLY_ACCESSIBLE_PROPERTY_KEY, false);

        try {
            // when
            forbiddenGetter.invoke(publication);

            // then
            fail("No exception was thrown from getter " + forbiddenGetter);

        } catch (final InvocationTargetException exception) {
            assertThat("Getter " + forbiddenGetter + " throws exception of correct type.", exception.getCause(),
                instanceOf(DataRestrictionViolationException.class)
            );
            assertThat("Getter " + forbiddenGetter + " throws exception with correct message.", exception.getCause().getMessage(),
                startsWith("Property is not available when publication is flagged as 'not publicly accessible':")
            );
        } catch (final Exception exception) {
            throw new Error("Failed to test '" + forbiddenGetter + " because of an error;"
                + " see stack trace below for details.", exception);
        }
    }

    @Test
    @UseDataProvider("allPublicGetters")
    public void permitsAllGetters_whenPublicationFlaggedAsPubliclyAvailable(final Method permittedGetter) throws Exception {

        // given
        setBeanProperty(PUBLICLY_ACCESSIBLE_PROPERTY_KEY, true);

        // some getters have arguments so we need to construct mocked instances and pass them in as parameters
        Object[] args = Arrays.stream(permittedGetter.getParameterTypes())
            .map(PublicationTest::newInstanceForClass)
            .toArray();

        try {
            // when
            permittedGetter.invoke(publication, args);

            // then
            // pass
        } catch (final Throwable throwable) {
            throwable.printStackTrace(); // helps with debugging
            throw new AssertionError(
                "No exception was expected to be thrown from '" + permittedGetter + "' but one was emitted;"
                    + " see stack trace below for details.", throwable
            );
        }
    }

    /**
     * Create an instance of a class that we can pass as a parameter in our calls to the getters
     * Currently only implemented for HstRequestContext
     */
    private static <R> R newInstanceForClass(Class<R> cls) {
        if (cls.equals(HstRequestContext.class)) {
            return (R) new MockHstRequestContext();
        } else {
            throw new RuntimeException("Don't know how to construct class " + cls);
        }
    }

    @DataProvider
    public static List<Method> allPublicGetters() {

        return stream(Publication.class.getDeclaredMethods())
            .filter(method -> Modifier.isPublic(method.getModifiers()))
            .filter(method -> !Modifier.isStatic(method.getModifiers()))
            .filter(method -> method.getName().startsWith("get") || method.getName().startsWith("is"))
            .filter(method -> !method.getReturnType().equals(Void.class))
            .collect(toList());
    }

    @DataProvider
    public static List<Method> gettersForbiddenInUpcomingPublication() {

        final List<String> gettersPermittedWhenUpcoming = asList(
            "getTitle",
            "getNominalPublicationDate",
            "isPubliclyAccessible",
            "getSelfLinkBean"
        );

        return allPublicGetters().stream()
            .filter(method -> !gettersPermittedWhenUpcoming.contains(method.getName()))
            .collect(toList());
    }

    private void setBeanProperty(final String propertyKey, final Object value) {
        beanProperties.put(propertyKey, value);
    }

    private static LocalDate toLocalDate(final Calendar calendar) {
        return LocalDate.from(
            LocalDateTime.ofInstant(
                calendar.toInstant(),
                calendar.getTimeZone().toZoneId()
            )
        );
    }
}
