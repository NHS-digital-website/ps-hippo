<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/structured-text.ftl">
<#include "./macro/publicationHeader.ftl">
<#include "../common/macro/sections/sections.ftl">
<#include "../common/macro/stickyNavSections.ftl">
<#include "../common/macro/fileMetaAppendix.ftl">
<#include "../common/macro/component/lastModified.ftl">
<#include "../common/macro/fileIconByMimeType.ftl">
<#include "../common/macro/component/pagination.ftl">
<#include "../common/macro/component/infoGraphic.ftl">
<#include "../common/macro/latestblogs.ftl">
<#include "../common/macro/component/calloutBox.ftl">
<#include "../common/macro/contentPixel.ftl">

<@hst.setBundle basename="publicationsystem.change,publicationsystem.survey,publicationsystem.interactive,publicationsystem.labels,publicationsystem.headers"/>


<#-- Add meta tags -->
<#include "../common/macro/metaTags.ftl">
<#assign document = publication />
<#assign idsuffix = slugify(publication.title) />
<#assign hasRelatedNews = publication.relatedNews?has_content>
<@metaTags></@metaTags>

<#macro restrictedContentOfUpcomingPublication>
    <@publicationHeader publication=publication restricted=true downloadPDF=false />

    <div class="grid-wrapper grid-wrapper--article" aria-label="Document Content">
        <div class="grid-row">
            <div class="column column--two-thirds page-block page-block--main">
                <div class="article-section">
                    <p data-uipath="ps.publication.upcoming-disclaimer"
                       class="strong" itemprop="description">(Upcoming, not yet
                        published)</p>
                </div>
            </div>
        </div>
    </div>
</#macro>

<@fmt.message key="headers.summary" var="summaryHeader" />
<@fmt.message key="headers.related-links" var="relatedLinksHeader" />
<@fmt.message key="headers.key-facts" var="keyFactsHeader" />
<@fmt.message key="headers.administrative-sources" var="administrativeResourcesHeader" />
<@fmt.message key="headers.datasets" var="datasetsHeader" />
<@fmt.message key="headers.resources" var="resourcesHeader" />
<@fmt.message key="headers.supplementary-information-requests" var="supplementaryHeader" />
<@fmt.message key="survey.lead-line" var="surveyTitle" />
<@fmt.message key="survey.second-line" var="surveyContent" />
<@fmt.message key="survey.hyperlink-text" var="surveyLinkText" />
<@fmt.message key="survey.date-label" var="surveyDateLabel" />
<@fmt.message key="interactive.header" var="interactiveHeader" />
<@fmt.message key="interactive.not-accessible-primary-text" var="interactiveAccessiblePrimaryText" />
<@fmt.message key="interactive.not-accessible-link-text" var="interactiveAccessibleSummaryText" />
<@fmt.message key="interactive.date-label" var="interactiveDateLabel" />
<@fmt.message key="change.date-label" var="changeDateLabel" />

<#assign hasOldKeyfacts = publication.keyFacts.elements?has_content || keyFactImageSections?has_content />
<#assign hasNewKeyfacts = (publication.keyFactsHead?? && publication.keyFactsHead.content?has_content)
|| (publication.keyFactsTail?? && publication.keyFactsTail.content?has_content)
|| (publication.keyFactInfographics?? && publication.keyFactInfographics?size >0)  />
<#assign hasSectionContent = document.sections?has_content />

<#macro fullContentOfPubliclyAvailablePublication>
    <@publicationHeader publication=publication restricted=false downloadPDF=true/>

    <#-- Content Page Pixel -->
    <@contentPixel publication.getCanonicalUUID() publication.title></@contentPixel>

    <div class="grid-wrapper grid-wrapper--article" aria-label="Document Content">
        <#if publication.updates?has_content || publication.changenotice?has_content>
            <div class="grid-row">
                <div class="column column--no-padding">
                    <div class="callout-box-group">
                        <#if publication.updates?has_content>
                            <#assign item = {} />
                            <#list publication.updates as update>
                                <#assign item += update />
                                <#assign item += {"calloutType":"update", "index":update?index} />
                                <@calloutBox item />
                            </#list>
                        </#if>

                        <#if publication.changenotice?has_content>
                            <#assign item = {} />
                            <#list publication.changenotice as changeData>
                                <#assign item += changeData />
                                <@fmt.formatDate value=changeData.date.time type="Date" pattern="d MMMM yyyy HH:mm a" timeZone="${getTimeZone()}" var="changeDateTime" />
                                <#assign item += {"date":changeDateTime, "dateLabel":changeDateLabel} />
                                <#assign item += {"calloutType":"change", "severity":"information", "index":changeData?index} />
                                <@calloutBox item />
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
        </#if>

        <div class="grid-row">
            <#if index?has_content && index?size gt 1>
                <div
                    class="column column--one-third page-block--sticky-nav page-block--sidebar article-section-nav-outer-wrapper">
                    <!-- start sticky-nav -->
                    <div id="sticky-nav">
                        <#assign links = [] />
                        <#list index as i>
                            <#assign links += [{ "url": "#" + slugify(i), "title": i }] />
                        </#list>
                        <@stickyNavSections getStickySectionNavLinks({"document": publication, "sections": links})></@stickyNavSections>
                    </div>
                    <!-- end sticky-nav -->
                </div>
            </#if>

            <div class="column column--two-thirds page-block page-block--main">

                <div id="summary"
                     class="article-section article-section--summary no-border">
                    <h2>${summaryHeader}</h2>
                    <div
                        itemprop="description"><@structuredText item=publication.summary uipath="ps.publication.summary" /></div>
                </div>

                <div data-uipath="ps.publication.body"></div>

                <#if hasOldKeyfacts || hasNewKeyfacts || publication.interactivetool?has_content>
                    <div class="article-section article-section--highlighted"
                         id="key-facts">
                        <div class="callout callout--attention">

                            <#-- New key facts take precedence (if has both, just display new)  -->
                            <#if hasNewKeyfacts>
                                <h2>${keyFactsHeader}</h2>

                            <#-- New version of key facts head section -->
                                <@hst.html hippohtml=publication.keyFactsHead contentRewriter=gaContentRewriter/>

                            <#-- see ${publication.keyFactInfographics} - its a loop of Infographic.java -->

                                <#list publication.keyFactInfographics as graphic>
                                    <@infoGraphic graphic />
                                </#list>

                            <#-- New version of key facts tail section -->
                            <#-- see ${publication.keyFactsTail}  -->
                                <@hst.html hippohtml=publication.keyFactsTail contentRewriter=gaContentRewriter/>

                            <#elseif hasOldKeyfacts>
                                <h2>${keyFactsHeader}</h2>

                                <#if publication.keyFacts.elements?has_content>
                                    <@structuredText item=publication.keyFacts uipath="ps.publication.key-facts" />
                                </#if>

                                <#if keyFactImageSections?has_content>
                                    <div
                                        data-uipath="ps.publication.key-fact-images">
                                        <@sections sections=keyFactImageSections />
                                    </div>
                                </#if>
                            </#if>

                            <#if publication.interactivetool?has_content>
                                <h3>${interactiveHeader}</h3>
                                <#list publication.interactivetool as interactiveToolData>
                                    <#assign item = {} />
                                    <#assign item += interactiveToolData />

                                    <@fmt.formatDate value=interactiveToolData.date.time type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" var="expiryDate" />
                                    <#assign item += {"date":expiryDate, "dateLabel":interactiveDateLabel} />

                                    <#assign item += {"calloutType":"interactive", "severity":"grey"} />

                                    <#if item.accessiblelocation?has_content>
                                        <#assign item += {"notAccessiblePrimaryText":interactiveAccessiblePrimaryText, "notAccessibleSummaryText":interactiveAccessibleSummaryText} />
                                    </#if>

                                    <#assign item += {"index":interactiveToolData?index} />

                                    <#assign item += {"narrow":true} />
                                    <@calloutBox item />
                                </#list>
                            </#if>

                        </div>
                    </div>
                </#if>


                <#if publication.survey?has_content>
                    <div id="publication-survey"
                         class="article-section article-section--summary no-border">
                        <#assign item = {} />
                        <#assign item += publication.survey />

                        <#assign item += {"title":surveyTitle, "content":surveyContent, "text":surveyLinkText} />

                        <@fmt.formatDate value=publication.survey.date.time type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" var="expiryDate" />
                        <#assign item += {"date":expiryDate, "dateLabel":surveyDateLabel} />

                        <#assign item += {"calloutType":"survey", "iconYellow":true, "severity":"important", "index":0} />
                        <#assign item += {"narrow":true} />
                        <@calloutBox item />
                    </div>
                </#if>

                <#if publication.administrativeSources?has_content>
                    <div class="article-section" id="administrative-sources">
                        <h2>${administrativeResourcesHeader}</h2>
                        <p itemprop="isBasedOn"
                           data-uipath="ps.publication.administrative-sources">
                            ${publication.administrativeSources}
                        </p>
                    </div>
                </#if>

                <#if publication.datasets?has_content>
                    <div class="article-section" id="data-sets">
                        <h2>${datasetsHeader}</h2>
                        <ul data-uipath="ps.publication.datasets">
                            <#list publication.datasets as dataset>
                                <li itemprop="hasPart" itemscope
                                    itemtype="http://schema.org/Dataset">
                                    <a itemprop="url"
                                       href="<@hst.link hippobean=dataset.selfLinkBean/>"
                                       title="${dataset.title}">
                                        <span
                                            itemprop="name">${dataset.title}</span>
                                    </a>
                                    <#list dataset.summary.elements as element>
                                        <meta itemprop="description"
                                              content="${element}"/>
                                    </#list>
                                    <meta itemprop="license"
                                          content="https://digital.nhs.uk/about-nhs-digital/terms-and-conditions"/>
                                </li>
                            </#list>
                        </ul>
                    </div>
                </#if>

                <#if publication.attachments?has_content || publication.resourceLinks?has_content>
                    <div class="article-section" id="resources">
                        <h2>${resourcesHeader}</h2>
                        <#if publication.attachments?has_content>
                            <ul data-uipath="ps.publication.resources-attachments"
                                class="list list--reset">
                                <#list publication.attachments as attachment>
                                    <li class="attachment" itemprop="distribution"
                                        itemscope
                                        itemtype="http://schema.org/DataDownload">
                                        <@externalstorageLink attachment.resource; url>
                                            <a title="${attachment.text}"
                                               href="${url}"
                                               class="block-link"
                                               onClick="logGoogleAnalyticsEvent('Download attachment','Publication','${attachment.resource.filename}');"
                                               onKeyUp="return vjsu.onKeyUp(event)"
                                               itemprop="contentUrl">
                                                <div class="block-link__header">
                                                    <@fileIconByMimeType attachment.resource.mimeType></@fileIconByMimeType>
                                                </div>
                                                <div class="block-link__body">
                                                    <span class="block-link__title"
                                                          itemprop="name">${attachment.text}</span>
                                                    <@fileMetaAppendix attachment.resource.length, attachment.resource.mimeType></@fileMetaAppendix>
                                                </div>
                                                <meta itemprop="license"
                                                      content="https://digital.nhs.uk/about-nhs-digital/terms-and-conditions"/>
                                                <meta itemprop="encodingFormat"
                                                      content="${attachment.resource.mimeType}"/>
                                                <meta itemprop="name"
                                                      content="${attachment.text}"/>
                                            </a>
                                        </@externalstorageLink>
                                    </li>
                                </#list>
                            </ul>
                        </#if>
                        <#if publication.resourceLinks?has_content>
                            <ul data-uipath="ps.publication.resources-links"
                                class="list">
                                <#list publication.resourceLinks as link>
                                    <li>
                                        <a href="${link.linkUrl}"
                                           onClick="logGoogleAnalyticsEvent('Link click','Publication','${link.linkUrl}');"
                                           onKeyUp="return vjsu.onKeyUp(event)"
                                           title="${link.linkText}">${link.linkText}</a>
                                    </li>
                                </#list>
                            </ul>
                        </#if>
                    </div>
                </#if>

                <#if publication.supplementaryInformation?has_content>
                    <div class="article-section" id="supplementary-information-requests">
                        <h2>${supplementaryHeader}</h2>
                        <div data-uipath="ps.publication.supplementary-information-requests">
                            <#list publication.supplementaryInformation as supData>
                                <#assign section = [{"sectionType": "download", "items": [{"linkType":"internal", "link":supData}]}] />
                                <@sections sections=section />
                            </#list>
                        </div>
                    </div>
                </#if>

                <#if hasRelatedNews>
                    <@latestblogs publication.relatedNews 'Publication' 'news-' + idsuffix 'Related news' />
                </#if>

                <#if publication.relatedLinks?has_content>
                    <div class="article-section" id="related-links">
                        <h2>${relatedLinksHeader}</h2>
                        <ul data-uipath="ps.publication.related-links" class="list">
                            <#list publication.relatedLinks as link>
                                <li>
                                    <a href="${link.linkUrl}"
                                       onClick="logGoogleAnalyticsEvent('Link click','Publication','${link.linkUrl}');"
                                       onKeyUp="return vjsu.onKeyUp(event)"
                                       title="${link.linkText}">${link.linkText}</a>
                                </li>
                            </#list>
                        </ul>
                    </div>
                </#if>

                <#if hasSectionContent>
                    <@sections document.sections></@sections>
                </#if>

                <@lastModified publication.lastModified></@lastModified>

                <div class="article-section no-border no-top-margin">
                    <@pagination publication/>
                </div>

            </div>
        </div>
    </div>
</#macro>

<#-- ACTUAL TEMPLATE -->
<#if publication?? >
<#-- Gather the related document links for PDF printing -->
    <#if publication.pages?has_content>
        <#assign relatedDocumentLinks = "" />
        <#list publication.pages as page>
            <@hst.link var="documentLink" hippobean=page />
            <#assign relatedDocumentLinks += documentLink + (!page?is_last)?then("; ", "") />
        </#list>
    </#if>

    <article class="article article--publication" itemscope
             itemtype="http://schema.org/Dataset" aria-label="Document Header"
             data-related-doc-links="${(relatedDocumentLinks?has_content)?then(relatedDocumentLinks, '')}">
        <meta itemprop="license"
              content="https://digital.nhs.uk/about-nhs-digital/terms-and-conditions"/>
        <#if publication.publiclyAccessible>
            <@fullContentOfPubliclyAvailablePublication/>
        <#else>
            <@restrictedContentOfUpcomingPublication/>
        </#if>
    </article>
    <#assign useIntraLogo = false />
    <#include "../common/scripts/print-pdf.js.ftl">
</#if>
