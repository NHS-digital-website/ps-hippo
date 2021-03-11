package uk.nhs.digital.ps.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;

import java.util.*;

@HippoEssentialsGenerated(internalName = "publicationsystem:legacypublication")
@Node(jcrType = "publicationsystem:legacypublication")
public class LegacyPublication extends PublicationBase {

    @HippoEssentialsGenerated(internalName = PropertyKeys.SUMMARY)
    public HippoHtml getSummary() {
        assertPropertyPermitted(PropertyKeys.SUMMARY);

        return getHippoHtml(PropertyKeys.SUMMARY);
    }

    @HippoEssentialsGenerated(internalName = PropertyKeys.KEY_FACTS)
    public HippoHtml getKeyFacts() {
        assertPropertyPermitted(PropertyKeys.KEY_FACTS);

        return getHippoHtml(PropertyKeys.KEY_FACTS);
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:publicationid")
    public Long getPublicationid() {
        return getSingleProperty("publicationsystem:publicationid");
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:gossid")
    public Long getGossid() {
        return getSingleProperty("publicationsystem:gossid");
    }

    @HippoEssentialsGenerated(internalName = "website:sections")
    public List<HippoBean> getSections() {
        return getChildBeansIfPermitted("website:sections", HippoBean.class);
    }
}
