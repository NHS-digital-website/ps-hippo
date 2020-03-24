package uk.nhs.digital.ps.workflow.searchableFlag;

import static uk.nhs.digital.ps.PublicationSystemConstants.INDEX_FILE_NAME;
import static uk.nhs.digital.ps.PublicationSystemConstants.LONDON_ZONE_ID;
import static uk.nhs.digital.ps.PublicationSystemConstants.PROPERTY_PUBLICATION_DATE;

import org.hippoecm.repository.HippoStdNodeType;
import org.hippoecm.repository.util.WorkflowUtils;
import org.onehippo.repository.documentworkflow.DocumentVariant;
import org.onehippo.repository.documentworkflow.task.AbstractDocumentTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.JcrQueryHelper;
import uk.nhs.digital.ps.PublicationSystemConstants;

import java.time.Clock;
import java.time.LocalDateTime;
import java.util.Calendar;
import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.query.QueryResult;

public class SearchableFlagTask extends AbstractDocumentTask {

    private static final Logger log = LoggerFactory.getLogger(SearchableFlagTask.class);

    private static final String SEARCHABLE_FLAG = "common:searchable";
    private static final String TYPE_PUBLICATION = "publicationsystem:publication";
    private static final String TYPE_DATASET = "publicationsystem:dataset";
    private static final String DOCUMENTS_ROOT_FOLDER = "/content/documents";

    private DocumentVariant variant;
    private boolean depublishing;
    private Session session;

    private final transient Clock clock;

    public SearchableFlagTask(Clock clock) {
        super();
        this.clock = clock;
    }

    @Override
    protected Object doExecute() throws RepositoryException {
        session = getWorkflowContext().getInternalWorkflowSession();

        processPublication();
        processDataset();

        return null;
    }

    private void processPublication() throws RepositoryException {
        Node publication = variant.getCheckedOutNode(session);
        if (!publication.isNodeType(TYPE_PUBLICATION)) {
            return;
        }

        // update all dataset documents belonging to this publication,
        // only if publication name is "content"
        if (INDEX_FILE_NAME.equals(publication.getName())) {
            Node folder = WorkflowUtils.getContainingFolder(variant, session).getNode(session);

            QueryResult res = JcrQueryHelper.findDescendantVariants(folder, PublicationSystemConstants.NODE_TYPE_DATASET, variant.getState());
            NodeIterator nodes = res.getNodes();
            boolean searchable = !depublishing && isPublic(publication.getProperty(PROPERTY_PUBLICATION_DATE).getDate());

            while (nodes.hasNext()) {
                nodes.nextNode().setProperty(SEARCHABLE_FLAG, searchable);
            }
        }
    }

    private void processDataset() throws RepositoryException {
        Node dataset = variant.getCheckedOutNode(session);

        // If we are not publishing, there is no need to change the searchable flag
        if (depublishing || !dataset.isNodeType(TYPE_DATASET)) {
            return;
        }

        Node parentPublication = findPublicationInFolder(dataset.getParent());

        if (parentPublication == null) {
            // no parent publication found
            log.error("Parent publication not found");
            log.error("failed for node" + dataset.getPath());
            return;
        }

        // get common:searchable value
        boolean searchable = isPublic(parentPublication
            .getProperty(PROPERTY_PUBLICATION_DATE).getDate());

        // apply it to dataset document(s)
        dataset.setProperty(SEARCHABLE_FLAG, searchable);
    }

    private Node findPublicationInFolder(Node folder) throws RepositoryException {
        if (DOCUMENTS_ROOT_FOLDER.equals(folder.getPath())) {
            return null;
        }

        NodeIterator nodes = folder.getNodes();
        while (nodes.hasNext()) {
            Node node = nodes.nextNode();
            if (isContentHandle(node)) {
                NodeIterator variants = node.getNodes(node.getName());
                while (variants.hasNext()) {
                    Node variantNode = variants.nextNode();
                    if (matchesPublicationVariant(variantNode)) {
                        return variantNode;
                    }
                }
            }
        }

        return findPublicationInFolder(folder.getParent());
    }

    private boolean matchesPublicationVariant(Node variantNode) throws RepositoryException {
        return TYPE_PUBLICATION.equals(variantNode.getPrimaryNodeType().getName())
            && variant.getState().equals(variantNode.getProperty(HippoStdNodeType.HIPPOSTD_STATE).getString());
    }

    private boolean isContentHandle(Node node) throws RepositoryException {
        return node.isNodeType("hippo:handle")
            && INDEX_FILE_NAME.equals(node.getName());
    }

    public void setVariant(DocumentVariant variant) {
        this.variant = variant;
    }

    public void setDepublishing(boolean depublishing) {
        this.depublishing = depublishing;
    }

    public boolean isPublic(Calendar publicationDate) {
        LocalDateTime publicationDateTime = publicationDate.toInstant()
            .atZone(LONDON_ZONE_ID).toLocalDateTime()
            .withHour(PublicationSystemConstants.HOUR_OF_PUBLICATION_RELEASE).withMinute(
                PublicationSystemConstants.MINUTE_OF_PUBLICATION_RELEASE)
            .withSecond(0);

        LocalDateTime currentDateTime = LocalDateTime.now(clock);

        return !currentDateTime.isBefore(publicationDateTime);
    }
}
