package uk.nhs.digital.ps.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;
import uk.nhs.digital.ps.beans.structuredText.StructuredText;

import java.util.List;

@HippoEssentialsGenerated(internalName = "publicationsystem:archive")
@Node(jcrType = "publicationsystem:archive")

public class Archive extends BaseDocument {

    public HippoBean getSelfLinkBean() {
        return getCanonicalBean().getParentBean();
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:Title")
    public String getTitle() {
        return getSingleProperty("publicationsystem:Title");
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:Summary")
    public StructuredText getSummary() {
        return new StructuredText(getSingleProperty("publicationsystem:Summary"));
    }

    public List<String> getFullTaxonomyList() {
        return HippoBeanHelper.getFullTaxonomyList(this);
    }

    public String[] getKeys() {
        return getMultipleProperty(PublicationBase.PropertyKeys.TAXONOMY);
    }

    public String[] getInformationType() {
        return getMultipleProperty(PublicationBase.PropertyKeys.INFORMATION_TYPE);
    }

    public String[] getGranularity() {
        return getMultipleProperty(PublicationBase.PropertyKeys.GRANULARITY);
    }

    public String[] getGeographicCoverage() {
        return geographicCoverageValuesToRegionValue(getMultipleProperty(PublicationBase.PropertyKeys.GEOGRAPHIC_COVERAGE));
    }

    public String getAdministrativeSources() {
        return getSingleProperty(PublicationBase.PropertyKeys.ADMINISTRATIVE_SOURCES);
    }
}
