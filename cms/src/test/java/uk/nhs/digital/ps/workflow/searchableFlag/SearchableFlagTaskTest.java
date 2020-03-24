package uk.nhs.digital.ps.workflow.searchableFlag;

import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;

import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;
import org.apache.sling.testing.mock.jcr.MockJcr;
import org.hippoecm.repository.HippoStdNodeType;
import org.hippoecm.repository.api.WorkflowContext;
import org.hippoecm.repository.api.WorkflowException;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.onehippo.repository.documentworkflow.DocumentHandle;
import org.onehippo.repository.documentworkflow.DocumentVariant;
import uk.nhs.digital.test.util.MockJcrRepoProvider;

import java.io.FileInputStream;
import java.time.Clock;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

@RunWith(DataProviderRunner.class)
public class SearchableFlagTaskTest {

    private SearchableFlagTask searchableFlagTask;
    private Session session;
    private Node rootNode = null;

    private static final String RPS_ROOT_FOLDER = "/content/documents/corporate-website/publication-system";

    @Before
    public void setUp() throws Exception {
        Clock clock = Clock
                .fixed(LocalDateTime.of(2017, 3, 2, 0, 0).toInstant(ZoneOffset.UTC),
                        ZoneId.systemDefault());
        searchableFlagTask = new SearchableFlagTask(clock);
        session = MockJcrRepoProvider.repoFromYaml("/test-data/search/SearchableFlagTaskTest/searchableFlagUnitTestJcrFixture.yml");
        rootNode = session.getRootNode();

        WorkflowContext workflowContext = mock(WorkflowContext.class);
        given(workflowContext.getInternalWorkflowSession()).willReturn(session);
        searchableFlagTask.setWorkflowContext(workflowContext);
    }

    @Test
    @UseDataProvider("unpublishDocuments")
    public void shouldUpdateDatasetOnDepublishTest(List<String> changed, List<String> unchanged) throws Exception {
        // mock query results
        MockJcr.setQueryResult(session, getQueryResults(singletonList(
            RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/dataset/dataset"
        )));

        // process publication and datasets
        execute("/accessible-publication-with-datasets/content", HippoStdNodeType.PUBLISHED, true);

        for (int i = 0; i < changed.size(); i++) {
            assertFalse(
                "common:searchable flag is set to false for " + changed.get(i),
                getNodeBooleanProperty(changed.get(i), "common:searchable")
            );
        }

        for (int i = 0; i < unchanged.size(); i++) {
            assertTrue(
                "common:searchable flag is set to true for " + unchanged.get(i),
                getNodeBooleanProperty(unchanged.get(i), "common:searchable")
            );
        }
    }

    @Test
    @UseDataProvider("datasetDocumentState")
    public void shouldUpdateDocumentWithGivenStatusTest(final String state, List<String> changed, List<String> unchanged) throws Exception {

        // process publication and datasets
        execute("/publication-with-datasets/dataset", state, false);

        for (int i = 0; i < changed.size(); i++) {
            assertFalse(
                "common:searchable flag is set to false for " + changed.get(i),
                getNodeBooleanProperty(changed.get(i), "common:searchable")
            );
        }

        for (int i = 0; i < unchanged.size(); i++) {
            assertTrue(
                "common:searchable flag is set to true for " + unchanged.get(i),
                getNodeBooleanProperty(unchanged.get(i), "common:searchable")
            );
        }
    }

    @Test
    @UseDataProvider("datasetInSubfolder")
    public void shouldUpdateDatasetFromSubfolder(final String state, List<String> changed, List<String> unchanged) throws Exception {

        // process datasets from within subfolder
        execute("/publication-with-datasets/subfolder/dataset", state, false);

        for (int i = 0; i < changed.size(); i++) {
            assertFalse(
                "common:searchable flag is set to false for " + changed.get(i),
                getNodeBooleanProperty(changed.get(i), "common:searchable")
            );
        }

        for (int i = 0; i < unchanged.size(); i++) {
            assertTrue(
                "common:searchable flag is set to true for " + unchanged.get(i),
                getNodeBooleanProperty(unchanged.get(i), "common:searchable")
            );
        }
    }

    private void execute(String path, String state, boolean depublishing) throws RepositoryException, WorkflowException {
        Node node = getNode(RPS_ROOT_FOLDER + path);
        DocumentHandle handle = new DocumentHandle(node);
        handle.initialize();
        DocumentVariant variant = handle.getDocuments().get(state);
        searchableFlagTask.setVariant(variant);
        searchableFlagTask.setDepublishing(depublishing);
        searchableFlagTask.setDocumentHandle(handle);
        searchableFlagTask.execute();
    }

    @DataProvider
    public static Object[][] datasetDocumentState() {
        return new Object[][]{
            {
                "draft",
                asList(
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[2]"
                ),
                asList(
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[2]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[3]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[3]",
                    // unrelated dataset should not be changed
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[3]"
                )
            },
            {
                "published",
                asList(
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset"
                ),
                asList(
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[2]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[3]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[3]",
                    // unrelated dataset should not be changed
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[3]"
                )
            }
        };
    }

    @DataProvider
    public static Object[][] unpublishDocuments() {
        return new Object[][]{
            {
                asList(
                    RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/dataset/dataset"
                ),
                asList(
                    RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/content/content[2]",
                    RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/content/content[3]",
                    RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/accessible-publication-with-datasets/dataset/dataset[3]",
                    // unrelated dataset should not be changed
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[3]"
                )
            }
        };
    }

    @DataProvider
    public static Object[][] datasetInSubfolder() {
        return new Object[][]{
            {
                "draft",
                asList(
                    RPS_ROOT_FOLDER + "/publication-with-datasets/subfolder/dataset/dataset[2]"
                ),
                asList(
                    // publication unchanged
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[2]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/content/content[3]",
                    // the second dataset attached to parent publication unchanged
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/dataset/dataset[3]",
                    // draft and live version unchanged
                    RPS_ROOT_FOLDER + "/publication-with-datasets/subfolder/dataset/dataset",
                    RPS_ROOT_FOLDER + "/publication-with-datasets/subfolder/dataset/dataset[3]",
                    // unrelated dataset should not be changed
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[2]",
                    RPS_ROOT_FOLDER + "/random-folder/dataset/dataset[3]"
                )
            }
        };
    }

    public List<Node> getQueryResults(List<String> paths) throws RepositoryException {
        List<Node> nodes = new ArrayList<>();

        for (int i = 0; i < paths.size(); i++) {
            nodes.add(getNode(paths.get(i)));
        }

        return nodes;
    }

    protected Node getNode(String path) throws RepositoryException {
        return rootNode.getNode(path);
    }

    protected Boolean getNodeBooleanProperty(String path, String propertyName) throws RepositoryException {
        return rootNode.getNode(path).getProperty(propertyName).getBoolean();
    }
}
