package org.hippoecm.frontend.plugins.cms.admin.updater

import org.apache.commons.lang.StringUtils
import org.hippoecm.repository.util.JcrUtils
import org.onehippo.repository.update.BaseNodeUpdateVisitor
import org.onehippo.repository.util.NodeTypeUtils

import javax.jcr.Node
import javax.jcr.NodeIterator

class MoveKeyfactsToSection extends BaseNodeUpdateVisitor {

    def subNodes = [
        "publicationsystem:KeyFactsHead",
        "publicationsystem:keyFactInfographics",
        "publicationsystem:KeyFactsTail",
        "publicationsystem:KeyFacts"
    ];

    boolean doUpdate(Node node) {
        log.debug "Updating node ${node.path}"
        try {
            if (node.hasNodes()) {
                return updateNode(node)
            }
        } catch (e) {
            log.error("Failed to process record.", e)
        }

        return false
    }

    boolean updateNode(Node publicationNode) {

        def path = publicationNode.getPath()
        def nodeType = publicationNode.getPrimaryNodeType().getName()

        log.info("attempting to update node: " + path + " => current node type: " + nodeType)

        subNodes.eachWithIndex{ String subNode, i ->

            if (publicationNode.hasNode(subNode)) {

                if (subNode.equals("publicationsystem:keyFactInfographics")) {

                    NodeIterator it = publicationNode.getNodes(subNode)
                    while (it.hasNext()) {
                        Node infoGraphicNode = publicationNode.addNode("publicationsystem:highlights", "website:infographic")
                        JcrUtils.copyTo(it.nextNode(), infoGraphicNode)
                    }
                    NodeIterator it2 = publicationNode.getNodes(subNode)
                    while (it2.hasNext()) {
                        it2.nextNode().remove()
                    }

                }

                if (subNode.equals("publicationsystem:KeyFactsHead") || subNode.equals("publicationsystem:KeyFactsTail") || subNode.equals("publicationsystem:KeyFacts")) {

                    if(StringUtils.isNotEmpty(publicationNode.getNode(subNode).getProperty("hippostd:content").toString())) {
                        def body = publicationNode.getNode(subNode)
                        Node section = publicationNode.addNode("publicationsystem:highlights","website:section")
                        Node bodyNode = section.addNode("website:html", "hippostd:html")

                        String property = body.getProperty("hippostd:content").toString()
                        bodyNode.setProperty("hippostd:content", JcrUtils.getStringProperty(body, "hippostd:content", ""))

                        if(body.getNodes().hasNext()) {
                            JcrUtils.copy(body.getNodes().nextNode(), body.getNodes().nextNode().getName(), bodyNode)
                        }

                        body.remove();
                    }

                }

                log.info("  UPDATED: test")
            }
        }

        return false
    }

    boolean undoUpdate(Node node) {
        throw new UnsupportedOperationException('Updater does not implement undoUpdate method')
    }
}
