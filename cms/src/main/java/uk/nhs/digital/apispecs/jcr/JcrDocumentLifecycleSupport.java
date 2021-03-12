package uk.nhs.digital.apispecs.jcr;

import static org.hippoecm.repository.util.JcrUtils.getNodePathQuietly;
import static org.hippoecm.repository.util.WorkflowUtils.Variant.PUBLISHED;
import static uk.nhs.digital.JcrNodeUtils.validateIsOfTypeHandle;
import static uk.nhs.digital.apispecs.jcr.JcrDocumentLifecycleSupport.StandardPropertyNames.PUBLICATION_DATE;

import org.hippoecm.repository.api.Document;
import org.hippoecm.repository.util.WorkflowUtils;
import org.onehippo.forge.content.exim.core.DocumentManager;
import uk.nhs.digital.ExceptionUtils;
import uk.nhs.digital.JcrDocumentUtils;
import uk.nhs.digital.JcrNodeUtils;

import java.time.Instant;
import java.util.Optional;
import javax.jcr.Node;
import javax.jcr.Session;

public class JcrDocumentLifecycleSupport {

    private final Node documentHandleNode;

    // Set when any of the properties have been updated and the document needs saving to persist the changes.
    private boolean dirty;

    // Populated only if isDirty.
    private DocumentManager documentManager;
    private Document draftDocumentVariant;
    private Node draftNodeCheckedOut;

    private JcrDocumentLifecycleSupport(final Node documentHandleNode) {
        validate(documentHandleNode);

        this.documentHandleNode = documentHandleNode;
    }

    public static JcrDocumentLifecycleSupport from(final Node documentHandleNode) {
        return new JcrDocumentLifecycleSupport(documentHandleNode);
    }

    /**
     * Sets property on 'draft' node.
     */
    public void setStringProperty(final String propertyName, final String value) {
        try {
            ensureInitialisedForEditing();

            JcrNodeUtils.setStringPropertyQuietly(draftNodeCheckedOut, propertyName, value);

            dirtySet();
        } catch (final Exception e) {
            throw new RuntimeException("Failed to update property " + propertyName + " on " + documentHandleNode, e);
        }
    }

    public Optional<String> getStringProperty(final String propertyName,
                                              final WorkflowUtils.Variant documentVariantType
    ) {
        return WorkflowUtils.getDocumentVariantNode(documentHandleNode, documentVariantType)
            .flatMap(node -> JcrNodeUtils.getStringPropertyQuietly(node, propertyName));
    }

    public Optional<Instant> getInstantProperty(final String propertyName,
                                              final WorkflowUtils.Variant documentVariantType
    ) {
        return WorkflowUtils.getDocumentVariantNode(documentHandleNode, documentVariantType)
            .flatMap(node -> JcrNodeUtils.getInstantPropertyQuietly(node, propertyName));
    }

    public void setInstantProperty(final String propertyName,
                                   final WorkflowUtils.Variant documentVariantType,
                                   final Instant instant
    ) {
        WorkflowUtils.getDocumentVariantNode(documentHandleNode, documentVariantType)
            .ifPresent(node -> JcrNodeUtils.setInstantPropertyQuietly(node, propertyName, instant));
    }

    /**
     * @return Date of last publication or {@linkplain Optional#empty()} if the document has not been published, yet.
     */
    public Optional<Instant> getLastPublicationInstant() {

        return WorkflowUtils.getDocumentVariantNode(documentHandleNode, PUBLISHED)
            .flatMap(node -> JcrNodeUtils.getInstantPropertyQuietly(node, PUBLICATION_DATE.jcrName()));
    }

    public void saveAndPublish() {
        save();
        publish();
    }

    @Override public String toString() {
        return "DocumentLifecycleSupport{documentHandleNode=" + getNodePathQuietly(documentHandleNode) + '}';
    }

    public void save() {
        try {
            saveSession();

            if (isDirty()) {
                documentManager.commitEditableDocument(draftDocumentVariant);

                dirtyUnset();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to save session for " + documentHandleNode, e);
        }
    }

    private void publish() {
        try {
            JcrDocumentUtils.publish(documentHandleNode);
        } catch (Exception e) {
            throw new RuntimeException("Failed to publish " + getNodePathQuietly(documentHandleNode), e);
        }
    }

    private void validate(final Node documentHandleCandidateNode) {
        try {
            validateIsOfTypeHandle(documentHandleCandidateNode);
        } catch (Exception e) {
            throw new RuntimeException("Failed to create document object for " + documentHandleCandidateNode, e);
        }
    }

    private Session getSession() {
        return JcrNodeUtils.getSessionQuietly(documentHandleNode);
    }

    private void saveSession() {
        JcrDocumentUtils.saveQuietly(getSession());
    }

    private void ensureInitialisedForEditing() {
        documentManager = JcrDocumentUtils.documentManagerFor(getSession());

        draftDocumentVariant = documentManager.obtainEditableDocument(documentHandleNode);

        draftNodeCheckedOut = ExceptionUtils.wrapCheckedException(() ->
            draftDocumentVariant.getCheckedOutNode(getSession())
        );
    }

    private void dirtySet() {
        this.dirty = true;
    }

    private void dirtyUnset() {
        this.dirty = false;
    }

    private boolean isDirty() {
        return dirty;
    }

    enum StandardPropertyNames {
        PUBLICATION_DATE("hippostdpubwf:publicationDate");

        private final String jcrName;

        StandardPropertyNames(final String jcrName) {
            this.jcrName = jcrName;
        }

        public String jcrName() {
            return jcrName;
        }
    }
}
