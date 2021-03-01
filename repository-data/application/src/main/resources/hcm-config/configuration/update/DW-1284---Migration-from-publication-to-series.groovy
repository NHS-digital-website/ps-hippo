package org.hippoecm.frontend.plugins.cms.admin.updater

import org.hippoecm.repository.util.JcrUtils
import org.onehippo.repository.update.BaseNodeUpdateVisitor
import javax.jcr.Node
import javax.jcr.RepositoryException
import javax.jcr.Session
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

// IMPORTS FOR SearchableTaxonomyTask
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

/*
This script takes the series fields (Granularity, Geographic Coverage, Administrative sources, Taxonomy and Information Types) from a file and finds
the corresponding series in the JCR and then overides the existing values with the ones coming from the file.
Bear in mind if a field of a series in the input is empty or blank, it will remove it in the JCR.


When runnin this script "XPath query" should be for example:
/jcr:root/content/documents/corporate-website//*[(@jcr:primaryType='publicationsystem:series')]

This script has a parameter called "inputFile", that is passed in the "parameters" field in the CMS script runner
(Setup icon/ Update editor).
An example would be:
{
    "inputFile" :  "/content/assets/assetsmiguel/seriesinfoexport.json/seriesinfoexport.json/hippogallery:asset"
}
As you can see, the value is a path in the JCR. That path is a file in the assets folder.
The last bit of the path "seriesinfoexport.json/hippogallery:asset" is the actual node that contains the content.
The content of that file should be a file in json format.

To upload that file in the CMS, sign-in in the CMS, go to "Content" section, in the dropdown change to "assets". Once in the assets,
if needed, create a folder and then in that folder choose "add file" and choose the file to upload.

Now to find out the path, go to the CMS console, sign-in, open /content/assets folder and try to find the node that represents
the file you have just uploaded in the CMS, once in the file, there is a property called path on top of the window,
it should look like this, for example:
"/content/assets/assetsmiguel/seriesinfoexport.json/seriesinfoexport.json/hippogallery:asset"

Once imported you can remove that file from the CMS and if you created a subfolder in assets, you can remove that too.

*/

class DW1284MigrationFromPublicationToSeries extends BaseNodeUpdateVisitor {

    private final static JSON_FIELD_TITLE = "Current Series Page Title"
    private final static JSON_FIELD_GRANULARITY = "Granularity"
    private final static JSON_FIELD_GEOGRAPHIC_COVERAGE = "Geographic Coverage"
    private final static JSON_FIELD_INFORMATION_TYPES = "Information Type"
    private final static JSON_FIELD_TAXONOMY = "Taxonomy topics"
    private final static JSON_FIELD_ADMINISTRATIVE_SOURCES = "AdministrativeSources"

    private final static JSON_FIELD_SHORT_TITLE = "shortTitle"
    private final static JSON_FIELD_FREQUENCY = "frequency"
    private final static JSON_FIELD_DATE_NAMING_CONVENTION = "dateNamingConvention"
    private final static JSON_FIELD_SUBTITLE = "subtitle"
    private final static JSON_FIELD_RESPONSIBLE_STASTICIAN = "responsibleStastician"
    private final static JSON_FIELD_RESPONSIBLE_TEAM = "responsibleTeam"


    private final static JCR_PROPERTY_TITLE = "publicationsystem:Title"
    private final static JCR_PROPERTY_GRANULARITY = "publicationsystem:Granularity"
    private final static JCR_PROPERTY_GEOGRAPHIC_COVERAGE = "publicationsystem:GeographicCoverage"
    private final static JCR_PROPERTY_INFORMATION_TYPE = "publicationsystem:InformationType"
    private final static JCR_PROPERTY_FULL_TAXONOMY = "common:FullTaxonomy"
    private final static JCR_PROPERTY_TAXONOMY_KEYS = "hippotaxonomy:keys"
    private final static JCR_PROPERTY_ADMINISTRATIVE_SOURCES = "publicationsystem:AdministrativeSources"

    private final static JCR_PROPERTY_SHORT_TITLE = "publicationsystem:shortTitle"
    private final static JCR_PROPERTY_SUBTITLE = "publicationsystem:subTitle"
    private final static JCR_PROPERTY_FREQUENCY = "publicationsystem:frequency"
    private final static JCR_PROPERTY_DATE_NAMING_CONVENTION = "publicationsystem:dateNaming"
    private final static JCR_PROPERTY_RESPONSIBLE_STASTICIAN = "publicationsystem:stastician"
    private final static JCR_PROPERTY_RESPONSIBLE_TEAM = "publicationsystem:team"


    Session session
    JSONArray jsonArray
    SearchableTaxonomyTask taxonomyTask;

    void initialize(Session session) {
        this.session = session
        this.taxonomyTask = new SearchableTaxonomyTask()

        try {
            String fileInJsonPath //= "/content/assets/assetsmiguel/seriesinfoexport.json/seriesinfoexport.json/hippogallery:asset"
            if (parametersMap.containsKey("inputFile")) {
                fileInJsonPath = parametersMap.get("inputFile")
            }
            Node nodeInputFileResource = session.getNode(fileInJsonPath)
            log.debug("Loading input file in path=" + nodeInputFileResource.getPath())
            String jsonString = nodeInputFileResource.getProperty("jcr:data").getString()

            jsonArray = new JSONArray(jsonString)
            log.info("\nInput data contains [" + jsonArray.length() + "] series")
            log.debug("\n\n\n")

        } catch (JSONException e) {
            log.error("Exception converting json: ", e)
            e.printStackTrace()
        }
    }

    boolean doUpdate(Node node) {
        // Query returns the hippo:handle node for the document
        // (which has the 3 variants)
        try {
            if (node.hasNodes()) {
                return updateNode(node)
            }
        } catch (e) {
            log.error("Failed to process node: " + node.getPath() + ", exception: " + e)
        }
        return false
    }

    boolean undoUpdate(Node node) {
        throw new UnsupportedOperationException('Updater does not implement undoUpdate method')
    }

    boolean updateNode(Node n) {
        JcrUtils.ensureIsCheckedOut(n)

        def path = n.getPath()
        def nodeType = n.getPrimaryNodeType().getName()
        def title = n.getProperty(JCR_PROPERTY_TITLE).getString()

        log.info("\n\nProcessing node")
        log.info("  path=" + path)
        log.info("  title=" + title)

        if (("publicationsystem:series".equals(nodeType)))  {
            SeriesNewFields series = getSeriesFieldsByTitle(title, jsonArray)
            if (series == null) {
                return false
            } else {
                return updateProperties(n, series)
            }
        }

        return false
    }

    class SeriesNewFields {
        public String title
        public String[] granularity
        public String[] geographicCoverage
        public String[] informationTypes
        public String[] taxonomy
        public String administrativeSources

        public String shortTitle
        public String subTitle
        public String frequency
        public String dateNaming
        public String responsibleStastician
        public String responsibleTeam


        public SeriesNewFields(JSONObject jsonObject) {
            this.title                 = jsonObject.get(JSON_FIELD_TITLE).toString()

            this.granularity           = jsonObject.get(JSON_FIELD_GRANULARITY).toString().replace('[', '').replace(']', '').split(",")
            if (this.granularity != null && this.granularity.length == 1 && this.granularity[0].trim().equals("")) {
                this.granularity = null
            }

            this.geographicCoverage    = jsonObject.get(JSON_FIELD_GEOGRAPHIC_COVERAGE).toString().replace('[', '').replace(']', '').split(",")
            if (this.geographicCoverage != null && this.geographicCoverage.length == 1 && this.geographicCoverage[0].trim().equals("")) {
                this.geographicCoverage = null
            }

            this.informationTypes      = jsonObject.get(JSON_FIELD_INFORMATION_TYPES).toString().replace('[', '').replace(']', '').split(",")
            if (this.informationTypes != null && this.informationTypes.length == 1 && this.informationTypes[0].trim().equals("")) {
                this.informationTypes = null
            }

            this.taxonomy              = jsonObject.get(JSON_FIELD_TAXONOMY).toString().replace('[', '').replace(']', '').split(",")
            if (this.taxonomy != null && this.taxonomy.length == 1 && this.taxonomy[0].trim().equals("")) {
                this.taxonomy = null
            }

            this.administrativeSources = jsonObject.get(JSON_FIELD_ADMINISTRATIVE_SOURCES).toString()

            this.shortTitle = jsonObject.get(JSON_FIELD_SHORT_TITLE).toString()
            this.subTitle = jsonObject.get(JSON_FIELD_SUBTITLE).toString()
            this.frequency = jsonObject.get(JSON_FIELD_FREQUENCY).toString()
            if (this.frequency != null && this.frequency.toLowerCase().indexOf("tbc") >= 0) {
                this.frequency = ""
            }
            this.dateNaming = jsonObject.get(JSON_FIELD_DATE_NAMING_CONVENTION).toString()
            if (this.dateNaming != null && this.dateNaming.toLowerCase().indexOf("tbc") >= 0) {
                this.dateNaming = ""
            }
            this.responsibleStastician = jsonObject.get(JSON_FIELD_RESPONSIBLE_STASTICIAN).toString()
            if (this.responsibleStastician != null && this.responsibleStastician.toLowerCase().indexOf("tbc") >= 0) {
                this.responsibleStastician = ""
            }
            this.responsibleTeam = jsonObject.get(JSON_FIELD_RESPONSIBLE_TEAM).toString()
            if (this.responsibleTeam != null && this.responsibleTeam.toLowerCase().indexOf("tbc") >= 0) {
                this.responsibleTeam = ""
            }
        }

        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("\ntitle: ").append(title)
            sb.append("\n granularity: ").append(arrayToString(granularity))
            sb.append("\n geographicCoverage: ").append(arrayToString(geographicCoverage))
            sb.append("\n informationTypes: ").append(arrayToString(informationTypes))
            sb.append("\n taxonomy: ").append(arrayToString(taxonomy))
            sb.append("\n administrativeSources: ").append(administrativeSources)

            sb.append("\n shortTitle: ").append(shortTitle)
            sb.append("\n subTitle: ").append(subTitle)
            sb.append("\n frequency: ").append(frequency)
            sb.append("\n dateNaming: ").append(dateNaming)
            sb.append("\n responsibleStastician: ").append(responsibleStastician)
            sb.append("\n responsibleTeam: ").append(responsibleTeam)
        }

        private String arrayToString(String[] myArray) {
            StringBuilder sb = new StringBuilder()
            for (int i=0; i < myArray.length; i++) {
                sb.append(myArray[i])
                sb.append(", ")
            }
            if(sb.length() > 0) {
                return sb.substring(0, sb.length()-2)
            } else {
                return ""
            }
        }
    }

    SeriesNewFields getSeriesFieldsByTitle(title, myArray) {
        try {
            Iterator iterator = myArray.iterator()
            Boolean found = false
            JSONObject item
            while (iterator.hasNext() && !found) {
                item = (JSONObject) iterator.next();
                String titleItem = item.get(JSON_FIELD_TITLE)
                if (title.equals(titleItem)) found = true;
            }
            if (found) {
                SeriesNewFields series = new SeriesNewFields(item)
//        log.debug("  series found=" + series.toString())
                log.debug("  series found")
                return series
            } else {
                log.debug("  series not found")
            }
        } catch (Exception ex) {
            log.error("  Exception in getSeriesFieldsByTitle=" + ex)
            ex.printStackTrace()
        }
        return null
    }

    boolean updateProperties(Node node, SeriesNewFields series) {
        if (series.granularity == null || series.granularity.length == 0) {
            node.setProperty(JCR_PROPERTY_GRANULARITY, (String[]) null)
        } else {
            node.setProperty(JCR_PROPERTY_GRANULARITY, series.granularity)
        }

        if (series.geographicCoverage == null || series.geographicCoverage.length == 0) {
            node.setProperty(JCR_PROPERTY_GEOGRAPHIC_COVERAGE, (String[]) null)
        } else {
            node.setProperty(JCR_PROPERTY_GEOGRAPHIC_COVERAGE, series.geographicCoverage)
        }

        if (series.informationTypes == null || series.informationTypes.length == 0) {
            node.setProperty(JCR_PROPERTY_INFORMATION_TYPE, (String[]) null)
        } else {
            node.setProperty(JCR_PROPERTY_INFORMATION_TYPE, series.informationTypes)
        }

        if (series.taxonomy == null || series.taxonomy.length == 0) {
            node.setProperty(JCR_PROPERTY_FULL_TAXONOMY, (String[]) null)
            node.setProperty(JCR_PROPERTY_TAXONOMY_KEYS, (String[]) null)
        } else {
            node.setProperty(JCR_PROPERTY_TAXONOMY_KEYS, series.taxonomy)
            taxonomyTask.updateFullTaxonomyAndSearchableTags(node)
        }

        node.setProperty(JCR_PROPERTY_ADMINISTRATIVE_SOURCES, series.administrativeSources)
        node.setProperty(JCR_PROPERTY_SHORT_TITLE, series.shortTitle)
        node.setProperty(JCR_PROPERTY_SUBTITLE, series.subTitle)
        node.setProperty(JCR_PROPERTY_FREQUENCY, getFrequencyValueInJCR(series.frequency))
        node.setProperty(JCR_PROPERTY_DATE_NAMING_CONVENTION, getDateNamingConventionInJCR(series.dateNaming))
//    node.setProperty(JCR_PROPERTY_RESPONSIBLE_STASTICIAN, series.responsibleStastician)
//    node.setProperty(JCR_PROPERTY_RESPONSIBLE_TEAM, series.responsibleTeam)

        return true
    }

    String getFrequencyValueInJCR(String frequency) {
        String frequencyAux = frequency.toLowerCase()
        if (frequencyAux.equals("twice a year")) {
            return "twiceyear"
        } else {
            return frequencyAux.replace(" ", "")
        }
    }

    String getDateNamingConventionInJCR(String dateNaming) {
        String dataNamingAux = dateNaming.toLowerCase()
        String returnValue = ""
        if (dataNamingAux.equalsIgnoreCase("At year of publication")) {
            returnValue = "1"
        } else if (dataNamingAux.equalsIgnoreCase("At year of coverage end")) {
            returnValue = "2"
        } else if (dataNamingAux.equalsIgnoreCase("At year ending of coverage end")) {
            returnValue = "3"
        } else if (dataNamingAux.equalsIgnoreCase("At month of publication")) {
            returnValue = "4"
        } else if (dataNamingAux.equalsIgnoreCase("At month of coverage end")) {
            returnValue = "5"
        } else if (dataNamingAux.equalsIgnoreCase("At quarter ending of coverage end")) {
            returnValue = "6"
        } else if (dataNamingAux.equalsIgnoreCase("Coverage range by year (e.g. 2018-19)")) {
            returnValue = "7"
        } else if (dataNamingAux.equalsIgnoreCase("Coverage range by month (e.g. March 2018 - Sept 2018)")) {
            returnValue = "8"
        } else if (dataNamingAux.equalsIgnoreCase("No date")) {
            returnValue = "9"
        } else {
            log.debug("----returnValue = " + returnValue)
            return returnValue
        }
    }

    /* Code taken from hippo proyect class SearchableTaxonomyTask. Originally that was in Java, it has been adapted to Groovy */
    public class SearchableTaxonomyTask {

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

        public Object updateFullTaxonomyAndSearchableTags(Node node) throws RepositoryException {
            try {
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
                    .map{value -> getWrapExceptions(value.&getString)}
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
                    .filter{node -> keys.contains(getWrapExceptions({ -> getTaxonomyKey(node)}))}
                    .flatMap{node -> getWrapExceptions({ -> getTermsAndSynonyms(node)})}
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
                                .map{value -> getWrapExceptions(value.&getString)}
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
                    .map {value -> new StringValue(value) }
                    .toArray {value2 -> new Value[value2]};
        }

        private Set<String> getFullTaxonomyKeys(Node document) throws RepositoryException {
            Value[] values = document.getProperty(TAXONOMY_KEYS_PROPERTY).getValues();
            Set<String> toReturn = Arrays.stream(values)
                    .map{value -> getWrapExceptions(value.&getString)}
                    .flatMap{key -> getWrapExceptions({ -> getTaxonomyList(key)})}
                    .collect(toSet());

            return toReturn
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
                    .filter{node -> getWrapExceptions({ -> getTaxonomyKey(node)}).equals(key)}
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
            Stream<Node> toReturn = streamChildTaxonomyNodes(node)
                    .flatMap{childNode -> Stream.concat(
                            Stream.of(childNode),
                            getDescendantTaxonomyNodes(childNode))}
            return toReturn
        }


        private Stream<Node> streamChildTaxonomyNodes(Node parentNode) {
            Stream<Node> toReturn = streamChildNodes(parentNode)
                    .filter { value -> getWrapExceptions(value.&getPrimaryNodeType)
                            .isNodeType(TAXONOMY_CATEGORY_NODE_TYPE)
                    }
            return toReturn;
        }

        @SuppressWarnings("unchecked")
        private Stream<Node> streamChildNodes(Node parentNode) {
            Iterable<Node> iterableNode = (Iterable<Node>) {-> getWrapExceptions(parentNode.&getNodes)}
            Stream<Node> toReturn = StreamSupport.stream(
                    iterableNode.spliterator(),
                    false
            );
            return toReturn
        }

        /**
         * This is not used in normal operation, session is set when we are hooking in the the task directly in
         */
        /*protected void setSession(Session session) {
            this.session = session;
        }*/

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
}
