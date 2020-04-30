package uk.nhs.digital.intranet.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import uk.nhs.digital.common.beans.BaseDocument;

import java.util.Calendar;

@Node(jcrType = "intranet:announcement")
public class Announcement extends BaseDocument {

    public String getTitle() {
        return getProperty("intranet:title");
    }

    public HippoBean getRelateddocument() {
        return getLinkedBean("intranet:relateddocument", HippoBean.class);
    }

    public Calendar getExpirydate() {
        return getProperty("intranet:expirydate");
    }

    public String getPriority() {
        return getProperty("intranet:priority");
    }

    public HippoHtml getDetails() {
        return getHippoHtml("intranet:details");
    }

    public HippoBean getLink() {
        return getBean("intranet:itemlink");
    }
}
