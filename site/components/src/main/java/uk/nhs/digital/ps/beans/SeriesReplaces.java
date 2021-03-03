package uk.nhs.digital.ps.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoCompound;
import org.hippoecm.hst.content.beans.standard.HippoHtml;

import java.util.Calendar;

@Node(jcrType = "publicationsystem:seriesreplaces")
public class SeriesReplaces extends HippoCompound {


    public Series getReplacementSeries() {
        return getLinkedBean("publicationsystem:replacementSeries", Series.class);
    }

    public HippoHtml getWhyReplaced() {
        return getHippoHtml("publicationsystem:whyReplaced");
    }

    public Calendar getChangeDate() {
        return getSingleProperty("publicationsystem:changeDate");
    }
}
