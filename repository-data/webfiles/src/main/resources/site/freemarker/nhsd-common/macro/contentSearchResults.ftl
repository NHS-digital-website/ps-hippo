<#ftl output_format="HTML">
<#-- @ftlvariable name="queryResponse" type="com.onehippo.search.integration.api.QueryResponse" -->

<#macro contentSearch queryResponse>
    <#assign searchResult = queryResponse.searchResult />
    <#assign totalResults = searchResult.numFound />
    <#assign documents = searchResult.documents />

    <div data-uipath="ps.search-results" data-totalresults="${(totalResults)!0}">
        <#if totalResults?? && totalResults gt 0>
            <div class="search-results-heading">
                <h1 class="search-results-heading__title">Search results</h1>

                <div class="search-results-heading__details">
                    <div class="search-results-heading__subcopy">
                        <div data-uipath="ps.search-results.description">
                            <span data-uipath="ps.search-results.count">${totalResults}</span>
                            result<#if totalResults gt 1>s</#if><#if query?has_content> containing '<strong>${query}</strong>',</#if> sorted by <strong>${sort}</strong>.
                        </div>
                    </div>

                    <div class="search-results-heading__sort">
                        <label for="sortBy">Sort by:</label>
                        <select id="sortBy"
                                onChange="updateQueryStringParameter(window.location.href, 'sort', this.value)"
                                data-uipath="ps.search-results.sort-selector">
                            <option title="Order by date" value="date"
                                    <#if sort?? && sort == 'date'>selected</#if>>
                                Date
                            </option>
                            <option title="Order by relevance"
                                    value="relevance"
                                    <#if sort?? && sort == 'relevance'>selected</#if>>
                                Relevance
                            </option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="search-results">
                <@contentSearchResults documents />
            </div>

        <#elseif query?has_content>
            <div class="search-results-heading no-border">
                <h1 class="search-results-heading__title"
                    data-uipath="ps.search-results.description">No results
                    for: ${query}</h1>
            </div>
        <#else>
            <div class="search-results-heading no-border">
                <h1 class="search-results-heading__title"
                    data-uipath="ps.search-results.description">No results for filters</h1>
            </div>
        </#if>
        <#include "../../include/pagination-content-search.ftl" />
    </div>
</#macro>


<#macro contentSearchResults documents>
    <#list documents as document>
        <#if document?? && document.residualProperties??>
            <#assign properties = document.residualProperties />
            <#if properties?? && properties.xmPrimaryDocType??>
                <#assign docType = properties.xmPrimaryDocType />
            </#if>
        </#if>

        <#if docType??>
            <#if docType == "publicationsystem:publication">
                <@contentSearchPublication document=document/>
            </#if>
            <#if docType == "publicationsystem:legacypublication">
                <@contentSearchLegacypublication document=document/>
            </#if>
            <#if docType == "publicationsystem:archive">
                <@contentSearchArchive document=document/>
            </#if>
            <#if docType == "publicationsystem:series">
                <@contentSearchSeries document=document/>
            </#if>
            <#if docType == "publicationsystem:dataset">
                <@contentSearchDataset document=document/>
            </#if>
            <#if docType == "nationalindicatorlibrary:indicator">
                <@contentSearchIndicator document=document/>
            </#if>
            <#if docType == "website:event">
                <@contentSearchEvent document=document/>
            </#if>
            <#if docType == "website:news">
                <@contentSearchNews document=document/>
            </#if>
            <#if docType == "website:publishedworkchapter">
                <@contentSearchPublishedworkchapter document=document/>
            </#if>
            <#if docType == "website:publishedwork">
                <@contentSearchPublishedWork document=document/>
            </#if>
            <#if docType == "website:general"
            ||  docType == "website:hub"
            ||  docType == "website:componentlist"
            ||  docType == "website:visualhub">
                <@contentSearchGenericSearchElement document=document type=docType isShowTitle=false />
            </#if>
            <#if docType == "website:gdprtransparency"
            ||  docType == "website:service"
            ||  docType == "website:roadmap"
            ||  docType == "website:roadmapitem"
            ||  docType == "website:glossarylist"
            ||  docType == "website:cyberalert"
            ||  docType == "website:blog"
            ||  docType == "website:bloghub"
            ||  docType == "website:person"
            ||  docType == "website:apimaster"
            ||  docType == "website:apiendpoint"
            ||  docType == "website:businessunit"
            ||  docType == "website:orgstructure"
            ||  docType == "website:supplementaryinformation"
            ||  docType == "website:apispecification">
                <@contentSearchGenericSearchElement document=document type=docType isShowTitle=true />
            </#if>
        </#if>
    </#list>
</#macro>

<#macro contentSearchPublication document>
    <#assign stampedPublication = false />
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
            <#if properties.informationType??>
                <#assign informationType = properties.informationType/>
                <#if informationType?has_content>
                    <#list informationType as type>
                        <#if type == "National statistics">
                            <#assign stampedPublication = true />
                            <#break>
                        </#if>
                    </#list>
                </#if>
            </#if>
        </#if>
    </#if>

    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean?? && contentBean.publiclyAccessible??>
        <#assign publiclyAccessible = contentBean.publiclyAccessible/>
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed ${stampedPublication?then(" cta--stamped", "")}"
         data-uipath="ps.search-results.result">
        <#if stampedPublication>
        <div class="cta__stamped-header">
            <div class="cta__stamped-header-col cta__stamped-header-col--left">
                </#if>
                <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.publication"/></span>
                </div>
                <#if hasTitle && hasUrl>
                    <a class="cta__title cta__button" href="${url}"
                       title="${title}"
                       data-uipath="ps.search-results.result.title">
                        ${title}
                    </a>
                </#if>

                <#if contentBean?? && contentBean.nominalPublicationDate??>
                    <span class="cta__meta"
                          data-uipath="ps.search-results.result.date"><@formatRestrictableDate value=contentBean.nominalPublicationDate/></span>
                </#if>
                <#if stampedPublication>
            </div>

            <div class="cta__stamped-header-col cta__stamped-header-col--right">
                <img src="<@hst.webfile  path="images/national-statistics-logo.svg"/>"
                     data-uipath="ps.search-results.result.national-statistics"
                     alt="National Statistics" title="National Statistics"
                     class="image-icon image-icon--large"/>
            </div>
        </div>
        </#if>
        <#if publiclyAccessible?? && publiclyAccessible>
            <p class="cta__text" data-uipath="ps.search-results.result.summary">
                <#if contentBean?? && contentBean.summary?? && contentBean.summary.firstParagraph??>
                    <@truncate text=contentBean.summary.firstParagraph size="300"/>
                </#if>
            </p>
        <#else>
            <span class="cta__meta" data-uipath="ps.search-results.result.summary">
                <@fmt.message key="labels.upcoming-publication"/>
            </span>
        </#if>
    </div>
</#macro>

<#macro contentSearchLegacypublication document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>

    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>

    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>
    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.publication"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}"
               title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.nominalPublicationDate??>
            <span class="cta__meta"
                  data-uipath="ps.search-results.result.date"><@formatRestrictableDate value=contentBean.nominalPublicationDate/></span>
        </#if>
    </div>
</#macro>

<#macro contentSearchArchive document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>

    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>
    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.archive"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}"
               title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.summary?? && contentBean.summary.firstParagraph??>
            <p class="cta__text" data-uipath="ps.search-results.result.summary">
                <@truncate text=contentBean.summary.firstParagraph size="300"/></p>
        </#if>
    </div>

</#macro>

<#macro contentSearchSeries document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>
    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean?? && contentBean.latestPublication??>
        <#assign latestPublication = contentBean.latestPublication/>
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.series"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.summary?? && contentBean.summary.firstParagraph??>
            <p class="cta__text" data-uipath="ps.search-results.result.summary">
                <@truncate text=contentBean.summary.firstParagraph size="300"/></p>
        </#if>
        <#if contentBean.showLatest && latestPublication??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.latest-publication">
                Latest publication:
                <a href="<@hst.link hippobean=latestPublication.selfLinkBean/>"
                   title="${latestPublication.title}">
                    ${latestPublication.title}
                </a>
            </p>
        </#if>
    </div>
</#macro>

<#macro contentSearchDataset document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>

    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.dataset"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.nominalDate??>
            <span class="cta__meta"
                  data-uipath="ps.search-results.result.date"><@formatRestrictableDate value=contentBean.nominalDate/></span>
        </#if>

        <#if contentBean?? && contentBean.summary?? && contentBean.summary.firstParagraph??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.summary.firstParagraph size="300"/></p>
        </#if>

    </div>
</#macro>

<#macro contentSearchIndicator document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
            <#if properties.publishedBy??>
                <#assign publishedBy = properties.publishedBy />
            </#if>
        </#if>
    </#if>
    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.indicator"/></span>
        </div>
        <#if hasUrl && hasTitle>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>

        <#if contentBean?? && contentBean.details?? && contentBean.details.briefDescription??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.brief-description">${contentBean.details.briefDescription}</p>
        </#if>

        <#if contentBean?? && contentBean.assuredStatus?? && contentBean.assuredStatus>
            <div class="cta__assurance">
                <div class="cta__metas">
                    <span class="cta__meta"
                          data-uipath="ps.search-results.result.assured-status"><@fmt.message key="labels.assured"/></span>
                    <span class="cta__meta"
                          data-uipath="ps.search-results.result.publisher-and-date">
                    <#if publishedBy??> <span
                            class="strong"><@fmt.message key="headers.publishedBy"/>:</span> ${publishedBy}.</#if>
                        <#if contentBean?? && contentBean.assuranceDate??>
                        <span class="strong"><@fmt.message key="headers.assured"/>:</span> <@formatDate date=contentBean.assuranceDate.time/></span>
                    </#if>
                </div>
                <div class="cta__badge">
                    <span data-uipath="ps.search-results.result.assured-indicator-icon"
                          title="Assured Indicator"
                          class="badge badge--assured"></span>
                </div>
            </div>
        <#else>
            <div class="cta__metas">
                <span class="cta__meta"
                      data-uipath="ps.search-results.result.assured-status"><@fmt.message key="labels.unassured"/></span>

                <#if contentBean?? && contentBean.publishedBy??>
                    <span class="cta__meta"
                          data-uipath="ps.search-results.result.publisher-and-date"><span
                                class="strong"><@fmt.message key="headers.publishedBy"/>:</span> ${contentBean.publishedBy}.

                        <@fmt.message key="headers.unassured"/>: <@formatDate date=contentBean.assuranceDate.time/></span>
                </#if>
            </div>
        </#if>
    </div>
</#macro>

<#macro contentSearchEvent document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>
    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.event"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>

        <#if contentBean?? && contentBean.shortsummary??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.shortsummary size="300"/></p>
        </#if>

        <#if contentBean?? && contentBean.events??>
            <#assign dateRangeData = getEventDateRangeData(contentBean.events) />
            <#if dateRangeData?size gt 0>
                <#if dateRangeData.comparableStartDate == dateRangeData.comparableEndDate>
                    <p class="cta__meta">
                        <span class="strong"><@fmt.message key="labels.date-label"/>: </span>
                        <span><@fmt.formatDate value=dateRangeData.minStartTime type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" /></span>
                    </p>
                <#else>
                    <p class="cta__meta">
                        <span class="strong"><@fmt.message key="labels.date-label"/>: </span>
                        <span>
                    <@fmt.formatDate value=dateRangeData.minStartTime type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" /> - <@fmt.formatDate value=dateRangeData.maxEndTime type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />
                </span>
                    </p>
                </#if>
            </#if>
        </#if>
    </div>
</#macro>

<#macro contentSearchNews document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>
    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.news"/></span>
        </div>
        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.shortsummary??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.shortsummary size="300"/></p>
        </#if>
        <#if contentBean?? && contentBean.publisheddatetime?? && contentBean.publisheddatetime.time??>
            <div class="cta__metas cta__metas--spaced">
                <p class="cta__meta">
                    <span class="strong"><@fmt.message key="about-us.newsDateLabel"/>: </span>
                    <@fmt.formatDate value=contentBean.publisheddatetime.time type="Date" pattern="yyyy-MM-dd HH:mm:ss" var="publishedDateTime" timeZone="${getTimeZone()}" />
                    <@fmt.formatDate value=contentBean.publisheddatetime.time type="Date" pattern="d MMMM yyyy" var="publishedDateTimeForHumans" timeZone="${getTimeZone()}" />
                    <time datetime="${publishedDateTime}">${publishedDateTimeForHumans}</time>
                </p>
            </div>
        </#if>
    </div>
</#macro>

<#macro contentSearchPublishedworkchapter document>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title??>
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.publishedworkchapter"/></span>
        </div>

        <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
            <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
        </#if>
        <#if contentBean??>
            <@hst.link var="url" hippobean=contentBean/>
            <#assign hasUrl = true />
        </#if>
        <#if contentBean?? && contentBean.publishedWork?? && contentBean.publishedWork.title??>
            <strong> ${contentBean.publishedWork.title} </strong>
            <br/>
        </#if>

        <#if hasTitle && hasUrl>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>

        <#if contentBean?? && contentBean.shortsummary??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.shortsummary size="300"/></p>
        </#if>
    </div>

</#macro>

<#macro contentSearchPublishedWork document>
    <#assign properties = document.residualProperties />
    <#if properties??>
        <#if properties.title??>
            <#assign title = properties.title />
            <#assign hasTitle = true />
        </#if>
    </#if>
    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>

    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <div>
            <span class="cta__label"
                  data-uipath="ps.search-results.result.type"><@fmt.message key="labels.publishedwork"/></span>
        </div>
        <#if hasUrl && hasTitle>
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if contentBean?? && contentBean.shortsummary??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.shortsummary size="300"/></p>
        </#if>
    </div>
</#macro>

<#macro contentSearchGenericSearchElement document type isShowTitle>
    <#if document?? && document.residualProperties??>
        <#assign properties = document.residualProperties />
        <#if properties??>
            <#if properties.title?? && type != "website:person">
                <#assign title = properties.title />
                <#assign hasTitle = true />
            </#if>
        </#if>
    </#if>

    <#if hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session)??>
        <#assign contentBean = hstRequest.requestContext.objectConverter.getObject(document.identifier, hstRequest.requestContext.session) />
    </#if>
    <#if contentBean??>
        <@hst.link var="url" hippobean=contentBean/>
        <#assign hasUrl = true />
    </#if>
    <div class="cta cta--detailed" data-uipath="ps.search-results.result">
        <#if isShowTitle>
            <#assign docList = type?split(":")>
            <#assign doctypeToDisplay = docList[docList?size-1]?lower_case >
            <div>
                <span class="cta__label"
                      data-uipath="ps.search-results.result.type"><@fmt.message key="labels.${doctypeToDisplay}"/></span>
            </div>
        </#if>
        <#if hasTitle && hasUrl && type != "website:person">
            <a class="cta__title cta__button" href="${url}" title="${title}"
               data-uipath="ps.search-results.result.title">
                ${title}
            </a>
        </#if>
        <#if hasUrl && type == "website:person">
            <a class="cta__title cta__button" href="${url}"
               title="${contentBean.title}"
               data-uipath="ps.search-results.result.title">
                ${contentBean.title}
            </a>

        </#if>
        <#if contentBean?? && contentBean.shortsummary??>
            <p class="cta__text"
               data-uipath="ps.search-results.result.summary"><@truncate text=contentBean.shortsummary size="300"/></p>
        </#if>
    </div>
</#macro>

<script>
    function updateQueryStringParameter(uri, key, value) {
        var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
        var separator = uri.indexOf('?') !== -1 ? "&" : "?";
        if (uri.match(re)) {
            uri = uri.replace(re, '$1' + key + "=" + value + '$2');
        } else {
            uri = uri + separator + key + "=" + value;
        }
        window.location.href = uri;
    }
</script>
