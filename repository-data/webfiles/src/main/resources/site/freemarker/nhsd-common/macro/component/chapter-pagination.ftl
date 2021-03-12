<#ftl output_format="HTML">

<#-- Note Page must implement uk.nhs.digital.pagination.Paginated -->
<#macro chapterNav page currentPageTitlePrefix="">
    <#assign chapterPagination = page.paginate() />
    <#if chapterPagination??>
        <nav class="chapter-pagination" aria-label="Chapter Navigation">
            <ul class="chapter-pagination__list grid-row">
                <#if chapterPagination.previous??>
                    <li class="chapter-pagination__list-item chapter-pagination-item--previous">
                        <p>
                            <span class="chapter-pagination__direction"
                                  aria-hidden="true">
                                Previous chapter
                            </span>
                            <a class="chapter-pagination__link"
                               href="<@hst.link hippobean=chapterPagination.previous.linkedBean />">
                                <span class="chapter-pagination__link-direction visually-hidden">Previous chapter: </span>
                                <span class="chapter-pagination__link-arrow"><img
                                            aria-hidden="true" alt="Left Arrow"
                                            src="<@hst.webfile path="/images/chapter-navigation/left-arrow.svg"/>"/></span><!--
   No space between elements --><span class="chapter-pagination__link-page">${chapterPagination.previous.title}</span>
                            </a>
                        </p>
                    </li>
                <#else>
                    <li class="chapter-pagination__list-item"></li>
                </#if>
                <li class="chapter-pagination__list-item chapter-pagination-item--current column-one-third">
                    <p>
                            <span class="chapter-pagination__direction">
                                ${currentPageTitlePrefix}${page.title}
                            </span>
                        <a class="chapter-pagination__link"
                           href="#chapter-index">
                            <span class="chapter-pagination__link-direction visually-hidden"></span>
                            <span class="chapter-pagination__link-arrow"><img
                                        aria-hidden="true" alt="Down Arrow"
                                        src="<@hst.webfile path="/images/chapter-navigation/down-arrow.svg"/>"/></span><!--
No space between elements --><span class="chapter-pagination__link-page">View all chapters</span>
                        </a>
                    </p>

                </li>
                <#if chapterPagination.next??>
                    <li class="chapter-pagination__list-item chapter-pagination-item--next column-one-third">
                        <p>
                            <span class="chapter-pagination__direction"
                                  aria-hidden="true">
                                Next chapter
                            </span>
                            <a class="chapter-pagination__link"
                               href="<@hst.link hippobean=chapterPagination.next.linkedBean />">
                                <span class="chapter-pagination__link-direction visually-hidden">Next chapter: </span>
                                <span class="chapter-pagination__link-page">${chapterPagination.next.title}</span><!--
   No space between elements --><span class="chapter-pagination__link-arrow"><img
                                            aria-hidden="true" alt="Right Arrow"
                                            src="<@hst.webfile path="/images/chapter-navigation/right-arrow.svg"/>"/></span>
                            </a>
                        </p>
                    </li>
                <#else>
                    <li class="chapter-pagination__list-item"></li>
                </#if>
            </ul>
        </nav>
    </#if>
</#macro>
