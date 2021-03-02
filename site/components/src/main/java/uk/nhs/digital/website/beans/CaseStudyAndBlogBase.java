package uk.nhs.digital.website.beans;

import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

public class CaseStudyAndBlogBase extends CommonFieldsBean {

    @HippoEssentialsGenerated(internalName = "website:dateofpublication")
    public Calendar getDateOfPublication() {
        return getSingleProperty("website:dateofpublication");
    }

    @HippoEssentialsGenerated(internalName = "website:authors")
    public List<HippoBean> getAuthors() {
        return getLinkedBeans("website:authors", HippoBean.class);
    }

    @HippoEssentialsGenerated(internalName = "website:authorname")
    public String getAuthorName() {
        return getSingleProperty("website:authorname");
    }

    @HippoEssentialsGenerated(internalName = "website:authorrole")
    public String getAuthorRole() {
        return getSingleProperty("website:authorrole");
    }

    @HippoEssentialsGenerated(internalName = "website:authorjobtitle")
    public String getAuthorJobTitle() {
        return getSingleProperty("website:authorjobtitle");
    }

    @HippoEssentialsGenerated(internalName = "website:authordescription")
    public HippoHtml getAuthorDescription() {
        return getHippoHtml("website:authordescription");
    }

    @HippoEssentialsGenerated(internalName = "website:authororganisation")
    public String getAuthorOrganisation() {
        return getSingleProperty("website:authororganisation");
    }

    @HippoEssentialsGenerated(internalName = "website:leadimage")
    public CorporateWebsiteImageset getLeadImage() {
        return getLinkedBean("website:leadimage", CorporateWebsiteImageset.class);
    }

    @HippoEssentialsGenerated(internalName = "website:leadimagealttext")
    public String getLeadImageAltText() {
        return getSingleProperty("website:leadimagealttext");
    }

    @HippoEssentialsGenerated(internalName = "website:leadimagecaption")
    public HippoHtml getLeadImageCaption() {
        return getHippoHtml("website:leadimagecaption");
    }

    @HippoEssentialsGenerated(internalName = "website:leadparagraph")
    public HippoHtml getLeadParagraph() {
        return getHippoHtml("website:leadparagraph");
    }

    @HippoEssentialsGenerated(internalName = "website:sections")
    public List<HippoBean> getSections() {
        return getChildBeansByName("website:sections");
    }

    @HippoEssentialsGenerated(internalName = "website:backstory")
    public HippoHtml getBackstory() {
        return getHippoHtml("website:backstory");
    }

    @HippoEssentialsGenerated(internalName = "website:casestudycategories")
    public String[] getCaseStudyCategories() {
        return getMultipleProperty("website:casestudycategories");
    }

    @HippoEssentialsGenerated(internalName = "website:twitterhashtag")
    public String[] getTwitterHashtag() {
        return getMultipleProperty("website:twitterhashtag");
    }

    @HippoEssentialsGenerated(internalName = "website:contactdetails")
    public HippoHtml getContactDetails() {
        return getHippoHtml("website:contactdetails");
    }

    @HippoEssentialsGenerated(internalName = "website:relatedsubjects")
    public List<HippoBean> getRelatedSubjects() {
        return getLinkedBeans("website:relatedsubjects", HippoBean.class);
    }

    @HippoEssentialsGenerated(internalName = "common:SearchableTags")
    public String[] getTopics() {
        return getMultipleProperty("common:SearchableTags");
    }

    public String getGuid() {
        return getSingleProperty("jcr:uuid");
    }

    public String getCategories() {
        List<String> strList = new ArrayList<>();

        List<HippoBean> relatedSubjectDoc = getLinkedBeans("website:relatedsubjects", HippoBean.class);
        for (HippoBean bean : relatedSubjectDoc) {
            String title = bean.getSingleProperty("website:title");
            strList.add(title);
        }
        String[] topics = getMultipleProperty("hippotaxonomy:keys");
        if (topics != null && topics.length > 0) {
            strList.addAll(Arrays.asList(topics));
        }
        return strList.size() > 0 ? strList.toString() : null;
    }

    public String getAllDescription() {
        StringBuilder descBuilder = new StringBuilder(getSummary().getContent())
            .append("\n").append(getBackstory().getContent())
            .append("\n").append(getLeadParagraph().getContent());
        return descBuilder.toString();
    }
}
