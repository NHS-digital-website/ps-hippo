<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/tabTileHeadings.ftl">
<#include "./macro/tabTileSection.ftl">

<#-- Resource bundle -->
<@hst.setBundle basename="rb.intra.search"/>
<@fmt.message key="page.title" var="overridePageTitle"/>
<@fmt.message key="labels.containing" var="textContaining"/>
<@fmt.message key="labels.results" var="resultsLabel"/>
<@fmt.message key="labels.noResults" var="noSearchResults"/>
<@fmt.message key="labels.moreResults" var="peopleMoreResults"/>
<@fmt.message key="labels.expiryBtn" var="sessionExpiryButtonLabel"/>
<@fmt.message key="headers.people" var="peopleHeader"/>
<@fmt.message key="headers.documents" var="documentHeader"/>

<#-- Add meta tags -->
<#include "macro/metaTags.ftl">
<@metaTags></@metaTags>

<#-- PARAMS related -->
<#assign PARAM_ALL = 'all'/>
<#assign PARAM_PEOPLE = 'people'/>
<#assign area = area?lower_case />
<#assign isAllTab = area = PARAM_ALL/>
<#assign isPeopleTab = area = PARAM_PEOPLE/>

<#-- Build tabs -->
<#assign tabs = [] />
<#assign totalCount = 0 />
<#list searchTabs as tab>
    <#if tab.tabName == 'All'>
        <#assign totalCount = tab.numberOfResults />
    </#if>

    <#assign tabs += [{
        "tileSectionHeading": tab.tabName,
        "tileCount": tab.numberOfResults
    }] />
</#list>

<#--Build 'people' link tiles-->
<#assign peopleLinks = []/>
<#if peopleResults?? && peopleResults?has_content>
    <@hst.link siteMapItemRefId="person" var="personLink" />

    <#list peopleResults as person>
        <#assign dept = (person.department?? && person.department?has_content)?then(person.department, "") />
        <#assign peopleLinks += [{
        "title": person.displayName,
        "linkType":"external",
        "link": personLink + "/" + person.id,
        "type": "People",
        "dept": dept
        }] />
    </#list>
</#if>

<#--Build 'news' link tiles-->
<#assign documentLinks = [] />
<#list pageable.items as item>
    <#assign documentLinks += [{
    "title": item.searchResultTitle,
    "linkType": "internal",
    "link": item,
    "modified": item.lastModified,
    "summary": item.shortsummary,
    "type": item.searchResultType
    }] />
</#list>

<article class="article article--intranet-home">
    <#if searchTabs?has_content>
        <div class="grid-wrapper">
            <div class="grid-row top-margin-20">
                <form role="search" method="get" class="search-banner__form" id="search" aria-label="intra-search-form">
                    <div>
                        <input type="text" name="query" id="query" class="search-banner__input" placeholder="Search" value="${query!""}" aria-label="intra-search-input" style="background-color: white">
                    </div>
                </form>
            </div>
            <div class="grid-row">
                <@tabTileHeadings tabs "search" area query />
            </div>
        </div>
    </#if>
    <div class="grid-wrapper grid-wrapper--article">
        <div class="grid-row">
            <div class="column column--one-quarter page-block page-block--sidebar article-section-nav-outer-wrapper">
                <#--INSERT FILTERS HERE-->
            </div>

            <div class="column column--three-quarters page-block page-block--main">
                <div class="article-section">
                    <#assign queryResultsString = (query?? && query?has_content)?then(textContaining + " '" + query + "'", "") />
                    <span class="intra-info-tag intra-info-tag--bg-flat intra-info-tag--txt-grey intra-info-tag--block-right">${totalCount} ${resultsLabel} ${queryResultsString}</span>

                    <div class="grid-row">
                        <div class="column column--reset">
                            <div class="tile-panel" role="tabpanel">
                                <#assign indexId = 1 />
                                <#assign isAllOrPeopleTab = isAllTab || isPeopleTab />
                                <#assign isFirstPaginationPage = isAllTab?then(pageable?has_content && pageable.currentPage == 1, true) />

                                <#assign hasPeopleLinks = peopleLinks?has_content />
                                <#assign hasDocumentsLinks = documentLinks?has_content/>
                                <#assign hasErrorMessages = accessTokenRequired?? || searchTermErrorMessage?? || apiErrorMessage?? />

                                <#assign displayHeaders = isAllTab && isFirstPaginationPage && hasDocumentsLinks && (hasPeopleLinks || hasErrorMessages) />

                                <#-- People -->
                                <#if displayHeaders>
                                    <span class="intra-info-tag intra-info-tag--txt-grey intra-info-tag--bg-flat intra-info-tag--block">${peopleHeader}</span>
                                </#if>
                                <#if isAllOrPeopleTab && hasErrorMessages && isFirstPaginationPage>
                                    <span class="intra-info-tag intra-info-tag--txt-black intra-info-tag--bg-flat intra-info-tag--block">
                                        <#if accessTokenRequired??>
                                            <@fmt.message key="text.accessTokenRequired"/>
                                        <#elseif searchTermErrorMessage??>
                                            <@fmt.message key="text.searchTermErrorMessage"/>
                                        <#elseif apiErrorMessage??>
                                            <@fmt.message key="text.apiErrorMessage"/>
                                        </#if>
                                    </span>
                                    <#if loginRequired>
                                        <div class="ctabtn--div">
                                            <a class="ctabtn--nhs-digital-button" href="${authorizationUrl}"><@fmt.message key="labels.peopleSearchBtn"/></a>
                                        </div>
                                    </#if>
                                </#if>
                                <#if isAllOrPeopleTab && hasPeopleLinks && isFirstPaginationPage>
                                    <#list peopleLinks as links>
                                        <div class="tile-panel-group">
                                            <@tabTileSection links indexId/>
                                        </div>
                                        <#assign indexId++ />
                                    </#list>
                                    <#if morePeople?? && isAllTab>
                                        <p class="intra-info-tag intra-info-tag--bg-flat intra-info-tag--block-right">
                                            <a href="${searchLink}?area=people&query=${query}">${peopleMoreResults}</a>
                                        </p>
                                    </#if>
                                </#if>

                                <#-- Documents -->
                                <#if displayHeaders>
                                    <span class="intra-info-tag intra-info-tag--txt-grey intra-info-tag--bg-flat intra-info-tag--block">${documentHeader}</span>
                                </#if>
                                <#if hasDocumentsLinks>
                                    <#assign peopleNumbers = 0 />
                                    <#if isAllTab && (pageable?has_content && pageable.currentPage != 1) >
                                        <#assign peopleNumbers = peopleLinks?size />
                                    </#if>
                                    <#assign indexId += pageable.startOffset + peopleNumbers/>
                                    <#list documentLinks as links>
                                        <div class="tile-panel-group">
                                            <@tabTileSection links indexId/>
                                        </div>
                                        <#assign indexId++ />
                                    </#list>
                                </#if>

                                <#-- No result message -->
                                <#if (isAllTab && !hasPeopleLinks && !hasDocumentsLinks) || (isPeopleTab && !hasPeopleLinks) || (!isAllOrPeopleTab && !hasDocumentsLinks)>
                                    <span class="intra-info-tag intra-info-tag--txt-black intra-info-tag--bg-flat intra-info-tag--block">${noSearchResults}</span>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="article-section no-border no-top-margin" id="intra-search-pagination">
                    <#if pageable.totalPages gt 1>
                        <#include "../include/pagination.ftl">
                    </#if>
                </div>
            </div>
        </div>
    </div>
</article>
