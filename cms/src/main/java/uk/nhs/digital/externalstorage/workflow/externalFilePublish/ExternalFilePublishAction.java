package uk.nhs.digital.externalstorage.workflow.externalFilePublish;


import static uk.nhs.digital.ps.PublicationSystemConstants.LONDON_ZONE_ID;

import org.apache.commons.scxml2.SCXMLExpressionException;
import org.apache.commons.scxml2.model.ModelException;
import org.hippoecm.repository.HippoStdNodeType;
import org.onehippo.cms7.services.HippoServiceRegistry;
import org.onehippo.repository.documentworkflow.action.AbstractDocumentTaskAction;
import uk.nhs.digital.externalstorage.s3.PooledS3Connector;

import java.time.Clock;

public class ExternalFilePublishAction extends AbstractDocumentTaskAction<ExternalFilePublishTask> {

    @Override
    protected ExternalFilePublishTask createWorkflowTask() {
        return new ExternalFilePublishTask(Clock.system(LONDON_ZONE_ID));
    }

    @Override
    protected void initTask(ExternalFilePublishTask task) throws ModelException, SCXMLExpressionException {
        super.initTask(task);
        task.setS3Connector(HippoServiceRegistry.getService(PooledS3Connector.class));
        task.setVariantState(HippoStdNodeType.UNPUBLISHED);
    }
}
