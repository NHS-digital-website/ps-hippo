package uk.nhs.digital.ps.beans;

import static org.hippoecm.hst.content.beans.query.builder.ConstraintBuilder.constraint;
import static uk.nhs.digital.ps.beans.PublicationBase.PropertyKeys.NOMINAL_DATE;

import org.hippoecm.hst.content.beans.Node;
import org.hippoecm.hst.content.beans.query.builder.HstQueryBuilder;
import org.hippoecm.hst.content.beans.query.exceptions.QueryException;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.content.beans.standard.HippoBeanIterator;
import org.hippoecm.hst.core.component.HstComponentException;
import org.hippoecm.repository.util.DateTools.Resolution;
import org.onehippo.cms7.essentials.dashboard.annotations.HippoEssentialsGenerated;
import uk.nhs.digital.ps.beans.structuredText.StructuredText;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.GregorianCalendar;
import java.util.List;

@HippoEssentialsGenerated(internalName = "publicationsystem:series")
@Node(jcrType = "publicationsystem:series")
public class Series extends BaseDocument {

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

    @HippoEssentialsGenerated(internalName = "publicationsystem:ShowLatest")
    public boolean getShowLatest() {
        return getSingleProperty("publicationsystem:ShowLatest", false);
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:attachments")
    public List<ExtAttachment> getAttachments() {
        return getChildBeansIfPermitted("publicationsystem:attachments", ExtAttachment.class);
    }

    @HippoEssentialsGenerated(internalName = "publicationsystem:resourceLinks")
    public List<RelatedLink> getResourceLinks() {
        return getChildBeansIfPermitted("publicationsystem:resourceLinks", RelatedLink.class);
    }

    public Publication getLatestPublication() throws HstComponentException, QueryException {
        if (!getShowLatest()) {
            return null;
        }

        HippoBean folder = getCanonicalBean().getParentBean();

        HippoBeanIterator hippoBeans = HstQueryBuilder.create(folder)
            .ofTypes(Publication.class)
            .where(constraint(NOMINAL_DATE).lessOrEqualThan(
                GregorianCalendar.from(ZonedDateTime.now(ZoneId.of("UTC"))
                    .minusHours(Publication.HOUR_OF_PUBLIC_RELEASE)
                    .minusMinutes(Publication.MINUTE_OF_PUBLIC_RELEASE)),
                Resolution.SECOND))
            .orderByDescending("publicationsystem:NominalDate")
            .limit(1)
            .build()
            .execute()
            .getHippoBeans();

        if (hippoBeans.hasNext()) {
            return (Publication) hippoBeans.nextHippoBean();
        }

        return null;
    }
}
