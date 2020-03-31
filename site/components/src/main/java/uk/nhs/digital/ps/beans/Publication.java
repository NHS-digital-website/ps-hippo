package uk.nhs.digital.ps.beans;

import org.apache.commons.collections.CollectionUtils;
import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;
import uk.nhs.digital.pagination.Paginated;
import uk.nhs.digital.pagination.Pagination;
import uk.nhs.digital.ps.beans.structuredText.StructuredText;
import uk.nhs.digital.website.beans.Infographic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@HippoEssentialsGenerated(internalName = "publicationsystem:publication")
@Node(jcrType = "publicationsystem:publication")
public class Publication extends PublicationBase implements Paginated {

    @HippoEssentialsGenerated(internalName = PublicationBase.PropertyKeys.SUMMARY)
    public StructuredText getSummary() {
        assertPropertyPermitted(PublicationBase.PropertyKeys.SUMMARY);

        return new StructuredText(getSingleProperty(PublicationBase.PropertyKeys.SUMMARY, ""));
    }

    @HippoEssentialsGenerated(internalName = PublicationBase.PropertyKeys.KEY_FACTS)
    public StructuredText getKeyFacts() {
        assertPropertyPermitted(PublicationBase.PropertyKeys.KEY_FACTS);

        return new StructuredText(getSingleProperty(PublicationBase.PropertyKeys.KEY_FACTS, ""));
    }

    @HippoEssentialsGenerated(internalName = PublicationBase.PropertyKeys.KEY_FACTS_HEAD)
    public HippoHtml getKeyFactsHead() {
        assertPropertyPermitted(PublicationBase.PropertyKeys.KEY_FACTS_HEAD);

        return getHippoHtml(PublicationBase.PropertyKeys.KEY_FACTS_HEAD);
    }

    @HippoEssentialsGenerated(internalName = PublicationBase.PropertyKeys.KEY_FACT_IMAGES)
    public List<ImageSection> getKeyFactImages() {
        return getChildBeansIfPermitted(PropertyKeys.KEY_FACT_IMAGES, ImageSection.class);
    }

    @HippoEssentialsGenerated(internalName = PropertyKeys.KEY_FACT_INFOGRAPHICS)
    public List<Infographic> getKeyFactInfographics() {
        return getChildBeansIfPermitted(PropertyKeys.KEY_FACT_INFOGRAPHICS, Infographic.class);
    }

    @HippoEssentialsGenerated(internalName = PublicationBase.PropertyKeys.KEY_FACTS_TAIL)
    public HippoHtml getKeyFactsTail() {
        assertPropertyPermitted(PublicationBase.PropertyKeys.KEY_FACTS_HEAD);

        return getHippoHtml(PublicationBase.PropertyKeys.KEY_FACTS_TAIL);
    }

    @HippoEssentialsGenerated(internalName = PropertyKeys.HIGHLIGHTS)
    public List<HippoBean> getHighlights() {
        if (CollectionUtils.isEmpty(getChildBeansIfPermitted(PropertyKeys.HIGHLIGHTS,
            HippoBean.class))) {
            return Collections.EMPTY_LIST;
        } else {
            return getChildBeansIfPermitted(PropertyKeys.HIGHLIGHTS,
                HippoBean.class);
        }
    }

    public List<PublicationPage> getPages() {
        assertPropertyPermitted(PublicationBase.PropertyKeys.PAGES);

        return getParentBean().getChildBeans(PublicationPage.class);
    }

    public List<IndexPage> getPageIndex() {
        List<IndexPage> pages = new ArrayList<>(getPages());

        if (!pages.isEmpty()) {
            // Add the Publication itself as the first link
            pages.add(0, new IndexPageImpl("Overview", this));
        }

        return pages;
    }

    public List<InteractiveTool> getInteractivetool() {
        return getChildBeansIfPermitted("publicationsystem:interactivetool",
            InteractiveTool.class);
    }

    public List<ChangeNotice> getChangenotice() {
        return getChildBeansIfPermitted("publicationsystem:changenotice",
            ChangeNotice.class);
    }

    public Survey getSurvey() {
        assertPropertyPermitted("publicationsystem:survey");
        return getHippoCompound("publicationsystem:survey", Survey.class);
    }

    @Override
    public Pagination paginate() {
        return new Pagination(null, getPageIndex().stream().skip(1).findFirst().orElse(null));
    }
}
