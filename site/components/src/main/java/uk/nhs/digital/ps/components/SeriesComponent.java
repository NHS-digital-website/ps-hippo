package uk.nhs.digital.ps.components;

import static org.apache.commons.collections.IteratorUtils.toList;
import static org.springframework.util.CollectionUtils.isEmpty;
import static uk.nhs.digital.ps.components.HippoComponentHelper.*;

import org.hippoecm.hst.container.RequestContextProvider;
import org.hippoecm.hst.content.beans.query.HstQuery;
import org.hippoecm.hst.content.beans.query.HstQueryResult;
import org.hippoecm.hst.content.beans.query.exceptions.QueryException;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.hst.core.component.HstComponentException;
import org.hippoecm.hst.core.component.HstRequest;
import org.hippoecm.hst.core.component.HstResponse;
import org.hippoecm.hst.core.request.HstRequestContext;
import org.onehippo.cms7.essentials.components.EssentialsContentComponent;
import org.onehippo.forge.selection.hst.contentbean.ValueList;
import org.onehippo.forge.selection.hst.util.SelectionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.ps.beans.*;

import java.util.*;
import java.util.stream.Collectors;

public class SeriesComponent extends EssentialsContentComponent {

    private static final Logger log = LoggerFactory.getLogger(SeriesComponent.class);

    @Override
    public void doBeforeRender(final HstRequest request, final HstResponse response) throws HstComponentException {
        super.doBeforeRender(request, response);

        final HstRequestContext requestContext = request.getRequestContext();
        final HippoBean contentBean = requestContext.getContentBean();

        final Series seriesIndexDocument;
        if (contentBean.isHippoFolderBean()) {
            final List<Series> seriesIndexDocuments = contentBean.getChildBeans(Series.class);
            if (seriesIndexDocuments.size() != 1) {
                reportInvalidTarget(request, contentBean, seriesIndexDocuments.size());
                return;
            }

            seriesIndexDocument = seriesIndexDocuments.get(0);
        } else if (contentBean instanceof Series) {
            seriesIndexDocument = (Series) contentBean;
        } else {
            reportInvalidInvocation(request, contentBean);
            return;
        }

        /* Setting frequency & date naming map on request  */
        final ValueList frequencyValueList =
            SelectionUtil.getValueListByIdentifier("frequency", RequestContextProvider.get());

        if (frequencyValueList != null) {
            request.setAttribute("frequencyMap", SelectionUtil.valueListAsMap(frequencyValueList));
        }

        final ValueList dateNamingConvention =
            SelectionUtil.getValueListByIdentifier("datenamingconvention", RequestContextProvider.get());

        if (dateNamingConvention != null) {
            request.setAttribute("dateNamingMap", SelectionUtil.valueListAsMap(dateNamingConvention));
        }

        request.setAttribute("series", seriesIndexDocument);

        try {
            final HstQuery query = requestContext.getQueryManager().createQuery(seriesIndexDocument.getParentBean(), Publication.class, LegacyPublication.class);
            query.addOrderByDescending("publicationsystem:NominalDate");

            final HstQueryResult hstQueryResult = query.execute();
            List<PublicationBase> allPublications = toList(hstQueryResult.getHippoBeans());

            Map<Boolean, List<PublicationBase>> publicationByStatus = allPublications.stream().collect(Collectors.groupingBy(PublicationBase::isPubliclyAccessible));
            List<PublicationBase> livePublications = publicationByStatus.get(true);
            List<PublicationBase> upcomingPublications = publicationByStatus.get(false);

            // Want upcoming in reverse date order to the closest to now is first
            if (!isEmpty(upcomingPublications)) {
                Collections.reverse(upcomingPublications);
            }

            if (!seriesIndexDocument.getShowLatest() && !isEmpty(livePublications)) {
                livePublications.sort(DateComparator.COMPARATOR);
            }

            if (!isEmpty(livePublications) && seriesIndexDocument.getShowLatest()) {
                livePublications.remove(0); //removes first publication as the publication available from Series.latestPublication
            }

            request.setAttribute("upcomingPublications", upcomingPublications);

            List<Pair> pastPublicationsAndSeriesChanges = new ArrayList<>();

            for (PublicationBase publicationBase : livePublications) {
                Pair<String, PublicationBase> pair = new Pair("publication", publicationBase, publicationBase.getNominalPublicationDateCalendar());
                pastPublicationsAndSeriesChanges.add(pair);
            }

            if (seriesIndexDocument.getSeriesReplaces() != null) {
                SeriesReplaces seriesReplaces = seriesIndexDocument.getSeriesReplaces();
                if (seriesReplaces.getChangeDate() != null) {
                    Pair<String, Series> pair = new Pair("replacedSeries", seriesReplaces, seriesReplaces.getChangeDate().getTime());
                    pastPublicationsAndSeriesChanges.add(pair);
                }
            }

            pastPublicationsAndSeriesChanges.sort(Comparator.comparing(Pair::getDate, Comparator.reverseOrder()));
            request.setAttribute("pastPublicationsAndSeriesChanges", pastPublicationsAndSeriesChanges);

        } catch (QueryException queryException) {
            log.error("Failed to find publications for series " + seriesIndexDocument.getTitle(), queryException);

            reportDisplayError(request, seriesIndexDocument.getTitle());
        }
    }

}
