package uk.nhs.digital.ps.beans;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.standard.HippoCompound;

import java.util.List;

@Node(jcrType = "publicationsystem:accessList")
public class AccessList extends HippoCompound {

    public List<ReleaseSubject> getReleaseSubjects() {
        return getChildBeansByName("publicationsystem:releaseSubject", ReleaseSubject.class);
    }

}
