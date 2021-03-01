package uk.nhs.digital.intranet.provider;

import static org.hippoecm.hst.content.beans.query.builder.ConstraintBuilder.and;
import static org.hippoecm.hst.content.beans.query.builder.ConstraintBuilder.constraint;
import static org.hippoecm.hst.content.beans.query.builder.ConstraintBuilder.or;

import org.hippoecm.hst.container.RequestContextProvider;
import org.hippoecm.hst.content.beans.query.HstQuery;
import org.hippoecm.hst.content.beans.query.HstQueryResult;
import org.hippoecm.hst.content.beans.query.builder.Constraint;
import org.hippoecm.hst.content.beans.query.builder.HstQueryBuilder;
import org.hippoecm.hst.content.beans.query.exceptions.QueryException;
import org.hippoecm.hst.content.beans.standard.HippoBean;
import org.hippoecm.repository.util.DateTools.Resolution;
import org.onehippo.cms7.essentials.components.ext.PageableFactory;
import org.onehippo.cms7.essentials.components.paging.Pageable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import uk.nhs.digital.common.components.ComponentUtils;
import uk.nhs.digital.intranet.beans.NewsInternal;
import uk.nhs.digital.intranet.beans.Task;
import uk.nhs.digital.intranet.enums.SearchArea;
import uk.nhs.digital.website.beans.Blog;
import uk.nhs.digital.website.beans.Team;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class BloomreachSearchProvider {

    private static final Map<SearchArea, Class[]> DOCUMENT_TYPES_BY_SEARCH_AREA;

    static {
        Map<SearchArea, Class[]> temp = new EnumMap<>(SearchArea.class);
        temp.put(SearchArea.ALL, new Class[]{Blog.class, NewsInternal.class, Team.class, Task.class});
        temp.put(SearchArea.NEWS, new Class[]{Blog.class, NewsInternal.class});
        temp.put(SearchArea.TASKS, new Class[]{Task.class});
        temp.put(SearchArea.TEAMS, new Class[]{Team.class});
        DOCUMENT_TYPES_BY_SEARCH_AREA = Collections.unmodifiableMap(temp);
    }

    private static final Logger LOG = LoggerFactory
        .getLogger(BloomreachSearchProvider.class);

    private final PageableFactory pageableFactory;

    public BloomreachSearchProvider(PageableFactory pageableFactory) {
        this.pageableFactory = pageableFactory;
    }

    public Pageable<HippoBean> getBloomreachResults(String queryString, int pageSize, int currentPage, SearchArea searchArea) {
        HstQuery query = getQuery(queryString, searchArea);
        query.setLimit(pageSize);
        query.setOffset((currentPage - 1) * pageSize);
        if (queryString == null) {
            query.addOrderByDescending("hippostdpubwf:lastModificationDate");
        }
        try {
            final HstQueryResult execute = query.execute();
            return pageableFactory
                .createPageable(execute.getHippoBeans(), execute.getTotalSize(),
                    pageSize, currentPage);
        } catch (QueryException e) {
            LOG.error("Error running query: {}", e.getMessage());
            LOG.debug("Query exception: ", e);
            return null;
        }
    }

    public int getBloomreachResultsCount(String queryString, SearchArea searchArea) {
        HstQuery query = getQuery(queryString, searchArea);
        query.setLimit(0);
        try {
            final HstQueryResult execute = query.execute();
            return execute.getTotalSize();
        } catch (QueryException e) {
            LOG.error("Error running query: {}", e.getMessage());
            LOG.debug("Query exception: ", e);
            return 0;
        }
    }

    private HstQuery getQuery(String queryString, SearchArea searchArea) {
        HstQueryBuilder queryBuilder = HstQueryBuilder.create(
            RequestContextProvider.get().getSiteContentBaseBean());

        queryBuilder.ofTypes(
            DOCUMENT_TYPES_BY_SEARCH_AREA.getOrDefault(searchArea,
                DOCUMENT_TYPES_BY_SEARCH_AREA.get(SearchArea.ALL))
        );

        List<Constraint> constraintList = new ArrayList<>();
        constraintList.add(
            or(
                constraint("common:searchable").equalTo(true),
                constraint("common:searchable").notExists()
            )
        );

        if (SearchArea.ALL.equals(searchArea) || SearchArea.NEWS.equals(searchArea)) {
            constraintList.add(
                or(
                    constraint("intranet:typeofnews").notExists(),
                    constraint("intranet:typeofnews").equalTo("permanent"),
                    constraint("intranet:expirydate")
                        .greaterOrEqualThan(Calendar.getInstance(), Resolution.HOUR)
                )
            );
        }

        final Optional<String> optionalSearchQuery = Optional.ofNullable(queryString);
        optionalSearchQuery.ifPresent(searchQuery -> {
            String queryIncWildcards = ComponentUtils.parseAndApplyWildcards(searchQuery);
            Constraint searchStringConstraint = or(
                constraint(".").contains(searchQuery),
                constraint(".").contains(queryIncWildcards)
            );
            constraintList.add(searchStringConstraint);
        });

        return queryBuilder.where(and(constraintList.toArray(new Constraint[0])))
            .build();
    }
}
