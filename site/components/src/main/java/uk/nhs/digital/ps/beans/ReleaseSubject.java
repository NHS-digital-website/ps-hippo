package uk.nhs.digital.ps.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoCompound;
import org.hippoecm.hst.content.beans.standard.HippoHtml;
import uk.nhs.digital.website.beans.JobRole;
import uk.nhs.digital.website.beans.Organisation;

import java.util.List;

@Node(jcrType = "publicationsystem:releaseSubject")
public class ReleaseSubject extends HippoCompound {

    public Organisation getOrganisation() {
        return getLinkedBean("publicationsystem:organisation", Organisation.class);
    }

    public List<JobRole> getRecipients() {
        return getLinkedBeans("publicationsystem:recipients", JobRole.class);
    }

    public HippoHtml getAdditionalDetail() {
        return getHippoHtml("publicationsystem:additionalDetail");
    }

}
