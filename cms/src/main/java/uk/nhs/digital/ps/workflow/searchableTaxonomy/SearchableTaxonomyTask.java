package uk.nhs.digital.ps.workflow.searchableTaxonomy;

import static java.util.stream.Collectors.toSet;
import static org.apache.cxf.common.util.CollectionUtils.isEmpty;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.jackrabbit.value.StringValue;
import org.onehippo.repository.documentworkflow.DocumentVariant;
import org.onehippo.repository.documentworkflow.task.AbstractDocumentTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.Value;

public class SearchableTaxonomyTask extends AbstractDocumentTask {

    private static final Logger log = LoggerFactory.getLogger(SearchableTaxonomyTask.class);

    static final String HIPPO_CLASSIFIABLE_PATH = "/hippo:namespaces/publicationsystem/series/editor:templates/_default_/classifiable";

    static final String FULL_TAXONOMY_PROPERTY = "common:FullTaxonomy";
    static final String SEARCHABLE_TAGS_PROPERTY = "common:SearchableTags";

    static final String TAXONOMY_NODE_NAME_PROPERTY = "essentials-taxonomy-name";
    static final String TAXONOMY_CATEGORY_NODE_TYPE = "hippotaxonomy:category";

    static final String TAXONOMY_CATEGORY_INFOS_PROPERTY = "hippotaxonomy:categoryinfos";
    static final String TAXONOMY_NAME_PROPERTY = "hippotaxonomy:name";
    static final String TAXONOMY_KEY_PROPERTY = "hippotaxonomy:key";
    static final String TAXONOMY_KEYS_PROPERTY = "hippotaxonomy:keys";
    static final String TAXONOMY_SYNONYMS_PROPERTY = "hippotaxonomy:synonyms";

    private DocumentVariant variant;
    private Session session;

    @Override
    protected Object doExecute() throws RepositoryException {
        try {
            session = getWorkflowContext().getInternalWorkflowSession();
            Node node = variant.getCheckedOutNode(session);

            if (node.hasProperty(TAXONOMY_KEYS_PROPERTY)) {
                createFullTaxonomyProperty(node);
                createSearchableTagsProperty(node);
            }
        } catch (RepositoryExceptionWrapper wrapper) {
            // If a function in a stream has caused an exception, we wrap it in an
            // unchecked exception so we need to rethrow it here
            throw wrapper.re;
        }
        return null;
    }

    @SuppressWarnings("WeakerAccess")
    protected void createSearchableTagsProperty(Node document) throws RepositoryException {
        Value[] values = document.getProperty(TAXONOMY_KEYS_PROPERTY).getValues();
        Set<String> keys = Arrays.stream(values)
            .map(value -> getWrapExceptions(value::getString))
            .collect(toSet());

        Set<String> searchableTags = getTaxonomyTermsAndSynonyms(keys);

        if (!isEmpty(searchableTags)) {
            try {
                document.setProperty(SEARCHABLE_TAGS_PROPERTY, stringsToValues(searchableTags));
            } catch (RepositoryException re) {
                log.error("Failed to set searchable tags on node: " + document, re);
            }
        }
    }

    private Set<String> getTaxonomyTermsAndSynonyms(Set<String> keys) throws RepositoryException {
        return getDescendantTaxonomyNodes(getTaxonomyTreeNode())
            .filter(node -> keys.contains(getWrapExceptions(() -> getTaxonomyKey(node))))
            .flatMap(node -> getWrapExceptions(() -> getTermsAndSynonyms(node)))
            .collect(toSet());
    }

    private Stream<String> getTermsAndSynonyms(Node taxonomyNode) throws RepositoryException {
        Node info = taxonomyNode.getNode(TAXONOMY_CATEGORY_INFOS_PROPERTY).getNode("en");

        String taxonomyName = info.getProperty(TAXONOMY_NAME_PROPERTY).getString();
        Stream<String> stream = Stream.of(taxonomyName);

        if (info.hasProperty(TAXONOMY_SYNONYMS_PROPERTY)) {
            stream = Stream.concat(
                stream,
                Arrays.stream(info.getProperty(TAXONOMY_SYNONYMS_PROPERTY).getValues())
                    .map(value -> getWrapExceptions(value::getString))
            );
        }

        return stream;
    }

    @SuppressWarnings("WeakerAccess")
    protected void createFullTaxonomyProperty(Node document) throws RepositoryException {
        Set<String> fullTaxonomyKeys = getFullTaxonomyKeys(document);
        Value[] fullTaxonomy = stringsToValues(fullTaxonomyKeys);

        // We have seen this happen when a document has only invalid taxonomy keys
        // Don't create the new property in this case
        if (ArrayUtils.isEmpty(fullTaxonomy)) {
            return;
        }

        try {
            document.setProperty(FULL_TAXONOMY_PROPERTY, fullTaxonomy);
        } catch (RepositoryException re) {
            log.error("Failed to set full taxonomy on node: " + document, re);
        }
    }

    private Value[] stringsToValues(Set<String> strings) {
        return strings.stream()
            .map(StringValue::new)
            .toArray(Value[]::new);
    }

    private Set<String> getFullTaxonomyKeys(Node document) throws RepositoryException {
        Value[] values = document.getProperty(TAXONOMY_KEYS_PROPERTY).getValues();
        return Arrays.stream(values)
            .map(value -> getWrapExceptions(value::getString))
            .flatMap(key -> getWrapExceptions(() -> getTaxonomyList(key)))
            .collect(toSet());
    }

    private Node getTaxonomyTreeNode() throws RepositoryException {
        String taxonomyName = session
            .getNode(HIPPO_CLASSIFIABLE_PATH)
            .getProperty(TAXONOMY_NODE_NAME_PROPERTY)
            .getString();

        // get the published taxonomy
        return session.getNode("/content/taxonomies/" + taxonomyName + "/" + taxonomyName);
    }

    private Stream<String> getTaxonomyList(String key) throws RepositoryException {

        Optional<Node> taxonomyNodeOptional = getDescendantTaxonomyNodes(getTaxonomyTreeNode())
            .filter(node -> getWrapExceptions(() -> getTaxonomyKey(node)).equals(key))
            .findAny();

        if (!taxonomyNodeOptional.isPresent()) {
            log.error("Couldn't find taxonomy key in tree: " + key);
            return Stream.empty();
        }

        Node taxonomyNode = taxonomyNodeOptional.get();
        ArrayList<String> taxonomyKeys = new ArrayList<>();
        while (taxonomyNode.getPrimaryNodeType()
            .isNodeType(TAXONOMY_CATEGORY_NODE_TYPE)) {

            taxonomyKeys.add(getTaxonomyKey(taxonomyNode));
            taxonomyNode = taxonomyNode.getParent();
        }

        return taxonomyKeys.stream();
    }

    private String getTaxonomyKey(Node node) throws RepositoryException {
        return node.getProperty(TAXONOMY_KEY_PROPERTY).getString();
    }

    private Stream<Node> getDescendantTaxonomyNodes(Node node) {
        return streamChildTaxonomyNodes(node)
            .flatMap(childNode -> Stream.concat(
                Stream.of(childNode),
                getDescendantTaxonomyNodes(childNode)
            ));
    }

    private Stream<Node> streamChildTaxonomyNodes(Node parentNode) {
        return streamChildNodes(parentNode)
            .filter((childNode) -> getWrapExceptions(childNode::getPrimaryNodeType)
                .isNodeType(TAXONOMY_CATEGORY_NODE_TYPE)
            );
    }

    @SuppressWarnings("unchecked")
    private Stream<Node> streamChildNodes(Node parentNode) {
        return StreamSupport.stream(
            ((Iterable<Node>) () -> getWrapExceptions(parentNode::getNodes)).spliterator(),
            false
        );
    }

    /**
     * This is not used in normal operation, session is set when we are hooking in the the task directly in
     */
    protected void setSession(Session session) {
        this.session = session;
    }

    /**
     * Handling for repository operations that throw exceptions that we can use in streams
     */
    static <T> T getWrapExceptions(RepositoryOperation<T> repositoryOperation) {
        if (repositoryOperation == null) {
            return null;
        }

        try {
            return repositoryOperation.get();
        } catch (RepositoryException re) {
            throw new RepositoryExceptionWrapper(re);
        }
    }

    public void setVariant(DocumentVariant variant) {
        this.variant = variant;
    }

    @FunctionalInterface
    interface RepositoryOperation<T> {
        T get() throws RepositoryException;
    }

    static class RepositoryExceptionWrapper extends RuntimeException {
        private RepositoryException re;

        RepositoryExceptionWrapper(RepositoryException re) {
            this.re = re;
        }

    }
}
