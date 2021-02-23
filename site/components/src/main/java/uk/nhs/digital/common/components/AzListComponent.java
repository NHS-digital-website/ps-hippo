package uk.nhs.digital.common.components;

import org.hippoecm.hst.content.beans.standard.HippoDocument;
import org.hippoecm.hst.core.component.HstRequest;
import org.hippoecm.hst.core.component.HstResponse;
import org.hippoecm.hst.core.parameters.ParametersInfo;
import org.onehippo.cms7.essentials.components.CommonComponent;
import uk.nhs.digital.common.components.info.AzListComponentInfo;

@ParametersInfo(type = AzListComponentInfo.class)
public class AzListComponent extends CommonComponent {
    @Override
    public void doBeforeRender(HstRequest request, HstResponse response) {
        super.doBeforeRender(request, response);

        final AzListComponentInfo componentParametersInfo = getComponentParametersInfo(request);

        String headerText = componentParametersInfo.getHeaderText();
        request.setAttribute("headerText", headerText);

        String buttonText = componentParametersInfo.getButtonText();
        request.setAttribute("buttonText", buttonText);

        String navigationDocumentPath = componentParametersInfo.getNavigationDocument();
        HippoDocument bean = this.getHippoBeanForPath(navigationDocumentPath, HippoDocument.class);

        request.setAttribute("navigationDocument", bean);
    }
}

