package eximgroovy

import org.apache.commons.lang.text.StrSubstitutor
import org.hippoecm.frontend.editor.plugins.resource.ResourceHelper
import org.hippoecm.repository.api.HippoWorkspace
import org.hippoecm.repository.api.WorkflowManager
import org.hippoecm.repository.impl.PropertyDecorator
import org.hippoecm.repository.util.JcrUtils
import org.onehippo.forge.content.exim.core.DocumentManager
import org.onehippo.forge.content.exim.core.impl.WorkflowDocumentManagerImpl
import org.onehippo.repository.update.BaseNodeUpdateVisitor
import org.onehippo.repository.util.JcrConstants

import javax.jcr.Node
import javax.jcr.PropertyIterator
import javax.jcr.Session
import javax.jcr.query.Query
import javax.jcr.query.QueryManager
import javax.jcr.query.QueryResult
import java.text.SimpleDateFormat

class MoveNewsYearWise extends BaseNodeUpdateVisitor {
    private static final String PROPERTY_LAST_MODIFIED = "jcr:lastModified";
    private static final String CONTENT_ROOT = "/content/documents/corporate-website/"
    private static final String AVAILABILITY = "live"

    WorkflowManager workflowManager
    DocumentManager documentManager
    String baseDestinationPath
    String moveDocFromPath
    String baseURL
    Session session
    QueryManager manager
    QueryResult ruleResult
    QueryResult newsResult
    Node ruleFolderNode = null
    Node newsFolderNode = null
    boolean createFile = false;

    def availability = [AVAILABILITY] as String[]
    String ruleFolder
    StringBuilder csvDataString = new StringBuilder("Year of Pub, Current URL, Desired URL");

    void initialize(Session session) {
        this.session = session
        workflowManager = ((HippoWorkspace) session.getWorkspace()).getWorkflowManager()
        documentManager = new WorkflowDocumentManagerImpl(session)

        baseDestinationPath = StrSubstitutor.replaceSystemProperties(parametersMap.get("baseDestinationPath"))
        moveDocFromPath = StrSubstitutor.replaceSystemProperties(parametersMap.get("moveDocFromPath"))
        baseURL = StrSubstitutor.replaceSystemProperties(parametersMap.get("baseURL"))
        ruleFolder = StrSubstitutor.replaceSystemProperties(parametersMap.get("ruleFolder"))

        manager = session.getWorkspace().getQueryManager();
        ruleResult = manager.createQuery("/jcr:root/content/urlrewriter/rules/" + ruleFolder, Query.XPATH).execute()
        if (ruleResult.getNodes().size() != 0) {
            ruleFolderNode = ruleResult.getNodes().next()
        }
        newsResult = manager.createQuery("/jcr:root/content/documents/corporate-website/news", Query.XPATH).execute()
        newsFolderNode = newsResult.getNodes().next()

    }

    @Override
    boolean doUpdate(Node node) {


        final parentPath = node.getParent().getPath()

        PropertyIterator iter1 = node.properties;
        while (iter1.hasNext()) {
            PropertyDecorator pd = iter1.nextProperty();
            if ("hippostdpubwf:publicationDate".equalsIgnoreCase(pd.name)) {
                JcrUtils.ensureIsCheckedOut(node)

                String publicationYear = pd.getDate().get(Calendar.YEAR)

                if (!parentPath.contains("/" + publicationYear + "/")
                    && (parentPath.equalsIgnoreCase(baseDestinationPath + "/" + node.name)
                    || parentPath.equalsIgnoreCase(moveDocFromPath + "/" + node.name))
                ) {
                    final String oldParentFolderPath = parentPath
                    String targetFolderPath = baseDestinationPath.concat("/" + publicationYear + "/").concat(node.name)
                    log.debug("Year of Pub." + publicationYear + " Current URL " + oldParentFolderPath + " Desired URL  " + targetFolderPath);
                    if (!newsFolderNode.hasNode(publicationYear)) {
                        log.error("No publication year exists " + publicationYear)
                        return true
                    } else if (ruleFolderNode == null) {
                        log.error("No Rule Folder Exists ")
                        return true
                    }
                    def tempOldURL = oldParentFolderPath.replace(CONTENT_ROOT, "/");
                    def oldURL = tempOldURL.replace("/news/", "/news-and-events/")
                    def newURL = targetFolderPath.replace(CONTENT_ROOT, baseURL);
                    log.debug("Year of Pub." + publicationYear + " OLD Url " + oldURL + " New Url " + newURL + " for Rule");
                    csvDataString.append(System.getProperty("line.separator"));
                    csvDataString.append(publicationYear + " , " + oldParentFolderPath.replace(CONTENT_ROOT, baseURL) + " , " + newURL);

                    session.move(oldParentFolderPath, targetFolderPath);
                    createRule(ruleFolderNode, node.name, oldURL, newURL)
                    createFile = true;
                }

                return true
            }
        }
    }

    @Override
    boolean undoUpdate(Node node) {
        throw new UnsupportedOperationException('Updater does not implement undoUpdate method')
    }

    void createRule(final Node node, final String nodeName, String oldURL, String newURL) {
        if (node.hasNode(nodeName)) {
            log.debug(" Node already EXISTS " + nodeName)
            return
        }
        JcrUtils.ensureIsCheckedOut(node)
        log.debug("  Creating Document rule")
        Node handle = node.addNode(nodeName, "hippo:handle")
        handle.addMixin("hippo:named")
        handle.setProperty("hippo:name", nodeName)
        handle.addMixin("mix:referenceable")
        Node document = handle.addNode(nodeName, "urlrewriter:rule")

        document.setProperty("urlrewriter:rulefrom", oldURL)
        document.setProperty("urlrewriter:ruleto", newURL)

        document.setProperty("hippostdpubwf:lastModifiedBy", "admin")
        document.setProperty("hippostd:stateSummary", "live")
        document.setProperty("urlrewriter:ruletype", "permanent-redirect")
        document.setProperty("hippo:availability", availability)
        document.setProperty("urlrewriter:ruledescription", "Rule for " + nodeName)
        document.setProperty("hippotranslation:id", UUID.randomUUID().toString())
        document.setProperty("hippostd:state", "published")
        document.setProperty("hippostdpubwf:publicationDate", Calendar.getInstance())
        document.setProperty("hippostdpubwf:lastModificationDate", Calendar.getInstance())
        document.setProperty("hippostdpubwf:lastModificationDate", Calendar.getInstance())
        document.setProperty("hippostdpubwf:createdBy", "admin")
        document.setProperty("hippostdpubwf:creationDate", Calendar.getInstance())

        log.debug("  Rule Created ")

        document.getSession().save()
    }

    private void loadFile() {
        if (createFile) {
            log.debug("Saving File")
            InputStream stream = new ByteArrayInputStream(csvDataString.toString().getBytes('UTF-8'))
            def result = manager.createQuery("/jcr:root/content/assets", Query.XPATH).execute()
            Node node = result.getNodes().nextNode();
            JcrUtils.ensureIsCheckedOut(node)
            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
            Node folder = node.addNode("News" + format1.format(Calendar.getInstance().getTime()) + ".csv", "externalstorage:resource")
            folder.setProperty(JcrConstants.JCR_DATA, ResourceHelper.getValueFactory(node).createBinary(stream));
            folder.setProperty(PROPERTY_LAST_MODIFIED, Calendar.getInstance())
            folder.setProperty("jcr:mimeType", "text/csv")

            folder.getSession().save()
        }
    }

    @Override
    void destroy() {
        loadFile()
    }

}
