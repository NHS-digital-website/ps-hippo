package uk.nhs.digital.externalstorage.workflow.externalFilePublish;

import static org.hippoecm.repository.HippoStdNodeType.HIPPOSTD_STATE;
import static org.hippoecm.repository.HippoStdNodeType.NT_FOLDER;
import static org.hippoecm.repository.HippoStdNodeType.PUBLISHED;
import static org.hippoecm.repository.HippoStdNodeType.UNPUBLISHED;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;
import static uk.nhs.digital.externalstorage.workflow.externalFilePublish.ExternalFilePublishTask.TAG_EARLY_ACCESS_KEY;
import static uk.nhs.digital.externalstorage.workflow.externalFilePublish.ExternalFilePublishTask.TAG_PUBLICATION_DATE;

import org.apache.sling.testing.mock.jcr.MockJcr;
import org.apache.sling.testing.mock.jcr.MockQueryResult;
import org.apache.sling.testing.mock.jcr.MockQueryResultHandler;
import org.hippoecm.repository.api.WorkflowContext;
import org.hippoecm.repository.api.WorkflowException;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.onehippo.repository.documentworkflow.DocumentHandle;
import uk.nhs.digital.externalstorage.ExternalStorageConstants;
import uk.nhs.digital.externalstorage.s3.PooledS3Connector;
import uk.nhs.digital.ps.PublicationSystemConstants;

import java.time.Clock;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.jcr.Node;
import javax.jcr.Property;
import javax.jcr.PropertyIterator;
import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

public class ExternalFilePublishTaskTest {

    @Mock
    private PooledS3Connector s3Connector;
    @Mock
    private WorkflowContext workflowContext;
    @Mock
    private Clock clockNow;

    private ExternalFilePublishTask externalFilePublishTask;
    private Session session;
    private Node rootNode;
    private Node testFolder;
    private final String testExternalReference = "ab/1c2d3e/one.pdf";
    private final Calendar testPublicationDateCalendar = new Calendar.Builder()
        .setDate(2010, Calendar.MARCH, 3).setTimeOfDay(0, 0, 0).build();
    private final long expectedPublicationDateEpoch = new Calendar.Builder()
        .setDate(2010, Calendar.MARCH, 3).setTimeOfDay(9, 30, 0).build().toInstant()
        .getEpochSecond();
    private final String testEarlyAccessKey = "ashdf783hiwrjnsiu3989SDKJHSAJsdhfjHJHDJSKFLK8798sudfjIUI";
    private final Map<String, String> expectedS3Tags = new HashMap<String, String>() {
        {
            put(TAG_PUBLICATION_DATE, String.valueOf(expectedPublicationDateEpoch));
            put(TAG_EARLY_ACCESS_KEY, testEarlyAccessKey);
        }
    };

    @Before
    public void setUp() throws RepositoryException {
        initMocks(this);

        Repository repository = MockJcr.newRepository();
        session = repository.login();
        rootNode = session.getRootNode();
        testFolder = rootNode.addNode("lorem-ipsum", NT_FOLDER);
        externalFilePublishTask = new ExternalFilePublishTask(clockNow);

        given(workflowContext.getInternalWorkflowSession()).willReturn(session);
        externalFilePublishTask.setWorkflowContext(workflowContext);
    }

    @Test
    public void shouldPublishAnyDocumentResource()
        throws WorkflowException, RepositoryException {
        Node document = getDocumentHandleWithVariant(getRandomDocumentType(),
            UNPUBLISHED);
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(document), testExternalReference));

        executeTask(document, externalFilePublishTask);

        then(s3Connector).should().publishResource(testExternalReference);
        then(s3Connector).should(never()).unpublishResource(anyString());
    }

    @Test
    public void shouldPublishAndTagFinalisedStandalonePublicationResources()
        throws WorkflowException, RepositoryException {
        Node document = getDocumentHandleWithVariant(getPublication(), UNPUBLISHED);
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(document), testExternalReference));
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2011, 3, 3, 0, 0).toInstant(ZoneOffset.UTC));

        executeTask(document, externalFilePublishTask);

        then(s3Connector).should().publishResource(testExternalReference);
        then(s3Connector).should(never()).unpublishResource(anyString());
        then(s3Connector).should().tagResource(testExternalReference,
            expectedS3Tags);
    }

    @Test
    public void shouldUnpublishAndTagUpcomingStandalonePublicationResources()
        throws WorkflowException, RepositoryException {
        Node document = getDocumentHandleWithVariant(getPublication(), UNPUBLISHED);
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(document), testExternalReference));
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2009, 3, 3, 0, 0).toInstant(ZoneOffset.UTC));

        executeTask(document, externalFilePublishTask);

        then(s3Connector).should(never()).publishResource(anyString());
        then(s3Connector).should().unpublishResource(testExternalReference);
        then(s3Connector).should().tagResource(testExternalReference,
            expectedS3Tags);
    }

    @Test
    public void shouldUnpublishAndTagDatasetResourcesPartOfUpcomingPublication()
        throws WorkflowException, RepositoryException {
        Node publication = getDocumentHandleWithVariant(getPublication(),
            UNPUBLISHED);
        Node dataset = getDocumentHandleWithVariant(getDataset(), UNPUBLISHED);
        String publicationResource = "ab/cdef12/lorem.pdf";
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(dataset), testExternalReference));
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(publication),
                publicationResource));
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2010, 3, 3, 9, 29, 59).toInstant(ZoneOffset.UTC));

        executeTask(dataset, externalFilePublishTask);

        then(s3Connector).should(never()).publishResource(anyString());
        then(s3Connector).should().unpublishResource(testExternalReference);
        then(s3Connector).should(never()).unpublishResource(publicationResource);
        then(s3Connector).should().tagResource(testExternalReference,
            expectedS3Tags);
    }

    @Test
    public void shouldPublishAndTagDatasetResourcesPartOfFinalisedPublication()
        throws WorkflowException, RepositoryException {
        Node publication = getDocumentHandleWithVariant(getPublication(),
            UNPUBLISHED);
        Node dataset = getDocumentHandleWithVariant(getDataset(), UNPUBLISHED);
        String publicationResource = "ab/cdef12/lorem.pdf";
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2010, 3, 3, 9, 30, 0).toInstant(ZoneOffset.UTC));

        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(dataset), testExternalReference));
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(publication),
                publicationResource));

        // when
        executeTask(dataset, externalFilePublishTask);

        then(s3Connector).should().publishResource(testExternalReference);
        then(s3Connector).should(never()).publishResource(publicationResource);
        then(s3Connector).should(never()).unpublishResource(anyString());
        then(s3Connector).should().tagResource(testExternalReference,
            expectedS3Tags);
    }

    @Test
    public void shouldPublishAndTagFinalisedPublicationAndItsDatasetsResources()
        throws WorkflowException, RepositoryException {
        // add Dataset to JCR
        Node dataset = getDocumentHandleWithVariant(getDataset(), PUBLISHED);
        Node publication = getDocumentHandleWithVariant(getPublication(),
            UNPUBLISHED);
        String publicationResource = "ab/cdef12/lorem.pdf";
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2010, 3, 10, 9, 30, 0).toInstant(ZoneOffset.UTC));

        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(dataset), testExternalReference));
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(publication),
                publicationResource));
        MockJcr.addQueryResultHandler(session,
            searchDatasetsHandle(dataset.getNode(dataset.getName())));

        // when publishing finalised publication
        executeTask(publication, externalFilePublishTask);

        // should be executed once for publication and once for dataset
        then(s3Connector).should(times(1)).publishResource(testExternalReference);
        then(s3Connector).should(times(1)).publishResource(publicationResource);
        then(s3Connector).should(never()).unpublishResource(anyString());
        then(s3Connector).should()
            .tagResource(testExternalReference, expectedS3Tags);
        then(s3Connector).should().tagResource(publicationResource, expectedS3Tags);
    }

    @Test
    public void shouldUnpublishAndTagUpcomingPublicationAndItsDatasetsResources()
        throws WorkflowException, RepositoryException {
        // add Dataset to JCR
        Node dataset = getDocumentHandleWithVariant(getDataset(), PUBLISHED);
        Node publication = getDocumentHandleWithVariant(getPublication(),
            UNPUBLISHED);
        String publicationResource = "ab/cdef12/lorem.pdf";
        when(clockNow.instant()).thenReturn(
            LocalDateTime.of(2010, 3, 2, 9, 30, 0).toInstant(ZoneOffset.UTC));

        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(dataset), testExternalReference));
        MockJcr.addQueryResultHandler(session,
            searchResourcesHandle(getVariantPath(publication),
                publicationResource));
        MockJcr.addQueryResultHandler(session,
            searchDatasetsHandle(dataset.getNode(dataset.getName())));

        // when publishing upcoming publication
        executeTask(publication, externalFilePublishTask);

        // should be executed once for publication and once for dataset
        then(s3Connector).should(times(1)).unpublishResource(testExternalReference);
        then(s3Connector).should(times(1)).unpublishResource(publicationResource);
        then(s3Connector).should(never()).publishResource(anyString());
        then(s3Connector).should()
            .tagResource(testExternalReference, expectedS3Tags);
        then(s3Connector).should().tagResource(publicationResource, expectedS3Tags);
    }

    private String getVariantPath(Node node) throws RepositoryException {
        return node.getNode(node.getName()).getPath();
    }

    private MockQueryResultHandler searchDatasetsHandle(Node dataset) {
        return mockQuery -> {
            if (mockQuery.getStatement().matches(
                "SELECT \\* FROM \\[publicationsystem:dataset].*\\[hippostd:state]\\s?=\\s?'published'")) {
                return new MockQueryResult(Arrays.asList(dataset));
            }
            return null;
        };
    }

    private MockQueryResultHandler searchResourcesHandle(final String nodePath,
        final String externalReference) {
        return mockQuery -> {
            String jcrSafeNodePath = org.apache.jackrabbit.util.Text
                .escapePath(nodePath);

            if (mockQuery.getStatement().matches(
                "SELECT \\* FROM \\[externalstorage:resource].*ISDESCENDANTNODE \\(\\['"
                    + jcrSafeNodePath + "']\\).*")) {
                return new MockQueryResult(
                    getQueryResultsWithSingleExternalResource(externalReference));
            }
            return null;
        };
    }

    private Node getPublication() throws RepositoryException {
        Node publicationVariant = rootNode
            .addNode("content", PublicationSystemConstants.NODE_TYPE_PUBLICATION);

        publicationVariant
            .setProperty(PublicationSystemConstants.PROPERTY_PUBLICATION_DATE,
                testPublicationDateCalendar);
        publicationVariant
            .setProperty(PublicationSystemConstants.PROPERTY_EARLY_ACCESS_KEY,
                testEarlyAccessKey);

        return publicationVariant;
    }

    private Node getRandomDocumentType() throws RepositoryException {
        Node randomTypeVariant = rootNode.addNode("test-document", "lorem:ipsum");

        return randomTypeVariant;
    }

    private Node getDataset() throws RepositoryException {
        Node datasetVariant = rootNode
            .addNode("test-document", PublicationSystemConstants.NODE_TYPE_DATASET);

        return datasetVariant;
    }

    private void executeTask(Node document, ExternalFilePublishTask task)
        throws WorkflowException {
        DocumentHandle documentHandle = new DocumentHandle(document);
        documentHandle.initialize();
        task.setDocumentHandle(documentHandle);
        task.setS3Connector(s3Connector);
        task.setVariantState(UNPUBLISHED);

        task.execute();
    }

    private Node getDocumentHandleWithVariant(Node documentVariant, String state)
        throws RepositoryException {
        String name = documentVariant.getName();
        Node handle = testFolder.addNode(name, "hippo:handle");

        // create new variant
        Node variant = handle
            .addNode(name, documentVariant.getPrimaryNodeType().getName());
        variant.setProperty(HIPPOSTD_STATE, state);

        // copy properties to variant
        PropertyIterator properties = documentVariant.getProperties();
        for (Property prop; properties.hasNext(); ) {
            prop = properties.nextProperty();
            variant.setProperty(prop.getName(), prop.getValue());
        }

        return handle;
    }

    private List<Node> getQueryResultsWithSingleExternalResource(String reference) {
        List<Node> nodes = new ArrayList<>();
        Node resources;

        try {
            resources = rootNode.addNode("resources");
            Node one = resources.addNode("one");
            one.setProperty(
                ExternalStorageConstants.PROPERTY_EXTERNAL_STORAGE_REFERENCE,
                reference);
            nodes.add(one);
        } catch (RepositoryException repositoryEx) {
            throw new RuntimeException(repositoryEx);
        }

        return nodes;
    }
}
