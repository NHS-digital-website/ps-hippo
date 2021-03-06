package uk.nhs.digital.website.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;

@HippoEssentialsGenerated(internalName = "website:glossaryitem")
@Node(jcrType = "website:glossaryitem")
public class GlossaryItem extends BaseCompound {

    @HippoEssentialsGenerated(internalName = "website:heading")
    public String getTitle() {
        return getSingleProperty("website:heading");
    }

    @HippoEssentialsGenerated(internalName = "website:definition")
    public HippoHtml getDefinition() {
        return getHippoHtml("website:definition");
    }

    @HippoEssentialsGenerated(internalName = "website:external")
    public String getExternal() {
        return getSingleProperty("website:external");
    }

    @HippoEssentialsGenerated(internalName = "website:internal")
    public HippoBean getInternal() {
        return getLinkedBean("website:internal", HippoBean.class);
    }

}
