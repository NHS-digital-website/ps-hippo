package uk.nhs.digital.common.components;

import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.core.component.HstRequest;
import org.hippoecm.hst.core.component.HstResponse;
import org.hippoecm.hst.core.parameters.ParametersInfo;
import org.onehippo.cms7.essentials.components.CommonComponent;
import uk.nhs.digital.common.components.info.NavigationBlockComponentInfo;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@ParametersInfo(type = NavigationBlockComponentInfo.class)
public class NavigationBlockComponent extends CommonComponent {

    @Override
    public void doBeforeRender(HstRequest request, HstResponse response) {
        super.doBeforeRender(request, response);

        NavigationBlockComponentInfo componentInfo = getComponentParametersInfo(request);
        final String theme = componentInfo.getTheme();
        final String size = componentInfo.getSize();
        final String position = componentInfo.getPosition();
        final String heading = componentInfo.getHeading();

        List<HippoBean> allDocuments = new ArrayList<>();
        HippoBean document1 = getHippoBeanForPath(componentInfo.getDocument1(), HippoBean.class);
        allDocuments.add(document1);
        HippoBean document2 = getHippoBeanForPath(componentInfo.getDocument2(), HippoBean.class);
        allDocuments.add(document2);
        HippoBean document3 = getHippoBeanForPath(componentInfo.getDocument3(), HippoBean.class);
        allDocuments.add(document3);
        HippoBean document4 = getHippoBeanForPath(componentInfo.getDocument4(), HippoBean.class);
        allDocuments.add(document4);
        HippoBean document5 = getHippoBeanForPath(componentInfo.getDocument5(), HippoBean.class);
        allDocuments.add(document5);
        HippoBean document6 = getHippoBeanForPath(componentInfo.getDocument6(), HippoBean.class);
        allDocuments.add(document6);

        request.setAttribute("theme", theme);
        request.setAttribute("size", size);
        request.setAttribute("position", position);
        request.setAttribute("heading", heading);
        request.setAttribute("documents", buildDocumentsList(allDocuments));
    }

    private List<HippoBean> buildDocumentsList(List<HippoBean> allDocuments) {
        return allDocuments.stream().filter(Objects::nonNull).collect(Collectors.toList());
    }
}
