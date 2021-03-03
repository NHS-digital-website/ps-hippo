<#ftl output_format="HTML">

<#-- @ftlvariable name="series" type="java.util.List<nhs.digital.ps.beans.Series>" -->
<#-- @ftlvariable name="publications" type="java.util.List<uk.nhs.digital.ps.beans.PublicationBase>" -->
<#-- @ftlvariable name="upcomingPublications" type="java.util.List<uk.nhs.digital.ps.beans.PublicationBase>" -->

<#include "../include/imports.ftl">
<#include "../common/macro/fileMetaAppendix.ftl">
<#include "../common/macro/updateGroup.ftl">
<#include "../common/macro/component/calloutBox.ftl">
<#include "../common/macro/stickyNavSections.ftl">
<#include "./macro/structured-text.ftl">
<#include "./macro/seriesDocumentHeader.ftl">
<#include "../common/macro/contentPixel.ftl">

<@hst.setBundle basename="publicationsystem.headers, publicationsystem.labels" />

<#-- Cache section headers and section checkers -->
<@fmt.message key="headers.summary" var="summarySectionHeader" />
<@fmt.message key="headers.about-this-publication" var="aboutSectionHeader" />
<@fmt.message key="headers.methodology" var="methodologySectionHeader" />
<@fmt.message key="headers.metadata" var="metadataSectionHeader" />
<@fmt.message key="headers.latest-statistics" var="latestStatisticsSectionHeader" />
<@fmt.message key="headers.upcoming-publications" var="upcomingPublicationsSectionHeader" />
<@fmt.message key="headers.past-publications" var="pastPublicationsSectionHeader" />
<@fmt.message key="headers.resources" var="resourcesSectionHeader" />
<@fmt.message key="headers.administrative-sources" var="administrativeResourcesHeader" />
<@fmt.message key="headers.pre-release-access" var="preReleaseAccessSectionHeader"/>

<#assign hasSummarySection = series.summary?? && series.summary?has_content />
<#assign hasLatestStatisticsSection = series.latestPublication?? && series.latestPublication?has_content />
<#assign hasAboutSection = series.about?? && series.about.content?has_content />
<#assign hasMethodologySection = series.methodology?? && series.methodology.content?has_content />
<#assign hasPastPublicationsSection = pastPublicationsAndSeriesChanges?? && pastPublicationsAndSeriesChanges?has_content />
<#assign hasUpcomingPublicationsSection = upcomingPublications?? && upcomingPublications?has_content />
<#assign hasResponsibleStatistician = series.statistician?? && series.statistician?has_content />
<#assign hasResponsibleTeam = series.team?? && series.team?has_content />
<#assign hasResourceLinks = series.resourceLinks?? && series.resourceLinks?has_content />
<#assign hasAttachments = series.attachments?? && series.attachments?has_content />
<#assign hasResourceSection = hasResourceLinks || hasAttachments />
<#assign hasAdminSourcesSection = document.administrativeSources?has_content />
<#assign hasPreReleaseAccessSection = series.releaseSubjects?? && series.releaseSubjects?has_content />
<#assign hasMetadataSection = (series.issn?? && series.issn?has_content) || (series.refNumber?? && series.refNumber?has_content) />


<#-- Add meta tags -->
<#include "../common/macro/metaTags.ftl">
<@metaTags></@metaTags>

<article class="article article--legacy-series" itemscope itemtype="http://schema.org/Series">
    <@contentPixel series.getCanonicalUUID() series.title></@contentPixel>
    <#-- [FTL-BEGIN] Big Blue Header -->
    <@seriesDocumentHeader document=series />
    <#-- [FTL-END] Big Blue Header -->

    <div class="grid-wrapper grid-wrapper--article" aria-label="Document Content">

        <#-- [FTL-BEGIN] Update group -->
        <@updateGroup document=series />
        <#-- [FTL-END] Update group -->

        <div class="grid-row">
            <div class="column column--one-third page-block page-block--sticky-nav page-block--sidebar article-section-nav-outer-wrapper">
                <!-- start sticky-nav -->
                <div id="sticky-nav">
                    <#assign links = [] />
                    <#if hasSummarySection>
                        <#assign links += [{ "url": "#" + slugify(summarySectionHeader), "title": summarySectionHeader }] />
                    </#if>
                    <#if hasLatestStatisticsSection>
                        <#assign links += [{ "url": "#" + slugify(latestStatisticsSectionHeader), "title": latestStatisticsSectionHeader }] />
                    </#if>
                    <#if hasAboutSection || hasResponsibleStatistician || hasResponsibleTeam>
                        <#assign links += [{ "url": "#" + slugify(aboutSectionHeader), "title": aboutSectionHeader }] />
                    </#if>
                    <#if hasMethodologySection>
                        <#assign links += [{ "url": "#" + slugify(methodologySectionHeader), "title": methodologySectionHeader }] />
                    </#if>
                    <#if hasUpcomingPublicationsSection>
                        <#assign links += [{ "url": "#" + slugify(upcomingPublicationsSectionHeader), "title": upcomingPublicationsSectionHeader }] />
                    </#if>
                    <#if hasPastPublicationsSection>
                        <#assign links += [{ "url": "#" + slugify(pastPublicationsSectionHeader), "title": pastPublicationsSectionHeader }] />
                    </#if>
                    <#if hasResourceSection>
                        <#assign links += [{ "url": "#" + slugify(resourcesSectionHeader), "title": resourcesSectionHeader }] />
                    </#if>
                    <#if hasAdminSourcesSection>
                        <#assign links += [{ "url": "#" + slugify(administrativeResourcesHeader), "title": administrativeResourcesHeader }] />
                    </#if>
                    <#if hasPreReleaseAccessSection>
                        <#assign links += [{ "url": "#" + slugify(preReleaseAccessSectionHeader), "title": preReleaseAccessSectionHeader }] />
                    </#if>
                    <#if hasMetadataSection>
                        <#assign links += [{ "url": "#" + slugify(metadataSectionHeader), "title": metadataSectionHeader }] />
                    </#if>

                    <@stickyNavSections getStickySectionNavLinks({"document": series, "sections": links})></@stickyNavSections>
                </div>
                <!-- end sticky-nav -->
            </div>
            <#-- Restore the bundle -->
            <@hst.setBundle basename="publicationsystem.headers, publicationsystem.labels" />

            <div class="column column--two-thirds page-block page-block--main">
                <div class="grid-row">
                    <#-- [FTL-BEGIN] mandatory 'Summary' section -->
                    <div class="article-section article-section--summary" id="${slugify(summarySectionHeader)}">
                        <h2>${summarySectionHeader}</h2>
                        <div class="rich-text-content" itemprop="description">
                            <@structuredText item=series.summary uipath="ps.series.summary" />
                        </div>
                    </div>
                    <#-- [FTL-END] mandatory 'Summary' section -->

                    <#-- [FTL-BEGIN] 'Latest statistics' section -->
                    <#if hasLatestStatisticsSection>
                    <div class="article-section" id="${slugify(latestStatisticsSectionHeader)}">
                        <h2>${latestStatisticsSectionHeader}</h2>

                        <#assign publishDate = series.latestPublication.nominalPublicationDate.dayOfMonth + " " +
                        series.latestPublication.nominalPublicationDate.month?capitalize + " " + series.latestPublication.nominalPublicationDate.year?c />

                        <div class="callout-box callout-box--grey" role="complementary" aria-labelledby="callout-box-heading-interactive-grey-latest-publication">
                            <div class="callout-box__icon-wrapper">
                                <@calloutBoxWebIcon />
                            </div>

                            <ul class="list list--reset cta-list" data-uipath="ps.series.publications-list.latest">
                                <div class="callout-box__content callout-box__content--narrow">
                                    <span class="callout-box__content-heading callout-box__content-heading--light callout-box__content--narrow-heading" id="callout-box-heading-interactive-grey-latest-publication">
                                        <li><h3 itemprop="name"><a href="<@hst.link hippobean=series.latestPublication />" class="cta__button" itemprop="url" title="${series.latestPublication.title}">${series.latestPublication.title}</a></h3></li>
                                    </span>

                                    <div class="callout-box__content-description">
                                        <div class="rich-text-content">
                                            <@truncate text=series.latestPublication.summary.firstParagraph size="150" />
                                        </div>
                                        <p class="callout-box__content-description-date"><@fmt.message key="labels.latest-publication-date-label"/> ${publishDate}</p>
                                    </div>
                                </div>
                            </ul>
                        </div>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Latest statistics' section -->

                    <#-- [FTL-BEGIN] 'About this publication' section -->
                    <#if hasAboutSection || hasResponsibleStatistician || hasResponsibleTeam>
                    <div class="article-section" id="${slugify(aboutSectionHeader)}">
                        <h2>${aboutSectionHeader}</h2>
                        <#if series.about.content?has_content>
                        <div class="rich-text-content" itemprop="description">
                            <@hst.html hippohtml=series.about contentRewriter=gaContentRewriter />
                        </div>
                        </#if>

                        <#if hasResponsibleStatistician || hasResponsibleTeam>
                        <h3><@fmt.message key="headers.responsible-parties"/></h3>
                        <div class="detail-list-grid detail-list-grid--regular">
                            <#if hasResponsibleStatistician>
                            <dl class="detail-list">
                                <dt class="detail-list__key"><@fmt.message key="labels.responsible-statistician"/></dt>
                                <dd class="detail-list__value"><a href="<@hst.link hippobean=series.statistician />">${series.statistician.title}</a></dd>
                            </dl>
                            </#if>
                            <#if hasResponsibleTeam>
                            <dl class="detail-list">
                                <dt class="detail-list__key"><@fmt.message key="labels.responsible-team"/></dt>
                                <dd class="detail-list__value"><a href="<@hst.link hippobean=series.team />">${series.team.title}</a></dd>
                            </dl>
                            </#if>
                        </div>
                        </#if>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'About this publication' section -->

                    <#-- [FTL-BEGIN] 'Methodology' section -->
                    <#if hasMethodologySection>
                    <div class="article-section" id="${slugify(methodologySectionHeader)}">
                        <h2>${methodologySectionHeader}</h2>
                        <div class="rich-text-content" itemprop="description">
                            <@hst.html hippohtml=series.methodology contentRewriter=gaContentRewriter />
                        </div>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Methodology' section -->

                    <#-- [FTL-BEGIN] 'Upcoming publications' section -->
                    <#if hasUpcomingPublicationsSection>
                    <div class="article-section" id="${slugify(upcomingPublicationsSectionHeader)}">
                        <h2>${upcomingPublicationsSectionHeader}</h2>
                        <@upcomingPublicationList/>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Upcoming publications' section -->


                    <#-- [FTL-BEGIN] 'Past publications' section -->
                    <#if hasPastPublicationsSection>
                        <div class="article-section" id="${slugify(pastPublicationsSectionHeader)}">
                            <h2>${pastPublicationsSectionHeader}</h2>
                            <#assign suppInfoList = [] />

                            <ul class="list list--reset cta-list" data-uipath="ps.series.publications-list.previous">
                            <#list pastPublicationsAndSeriesChanges as pastObject>
                                <#assign object = pastObject.object />
                                    <#if pastObject.type == "replacedSeries">
                                        <@fmt.formatDate value=object.changeDate.time?date var="changeDate" type="date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />

                                        <#assign objTitle>
                                            <a href="<@hst.link hippobean=object.replacementSeries/>" class="cta__button" itemprop="url">${object.replacementSeries.title}</a>
                                        </#assign>

                                        <#assign replacedSeriesData = {
                                            "title": objTitle,
                                            "content": object.whyReplaced,
                                            "severity": "information",
                                            "calloutType": "change",
                                            "date": changeDate,
                                            "narrow": true,
                                            "index": "series-replaced"
                                        } />

                                        <@calloutBox replacedSeriesData />

                                    <#elseif pastObject.type == "publication">
                                        <#assign publishDate = object.nominalPublicationDate.dayOfMonth + " " +
                                        object.nominalPublicationDate.month?capitalize + " " + object.nominalPublicationDate.year?c />

                                        <#assign pubData = {
                                            "title": object.title,
                                            "date": publishDate
                                        } />

                                        <div class="callout-box callout-box--grey" role="complementary" aria-labelledby="callout-box-heading-interactive-${slugify(pubData.title)}">
                                            <div class="callout-box__icon-wrapper">
                                                <@calloutBoxWebIcon />
                                            </div>

                                            <div class="callout-box__content callout-box__content--narrow">
                                                <span class="callout-box__content-heading callout-box__content-heading--light callout-box__content--narrow-heading" id="callout-box-heading-interactive-${slugify(pubData.title)}">
                                                    <li><h3 itemprop="name"><a href="<@hst.link hippobean=object.selfLinkBean/>" class="cta__button" itemprop="url" title="${pubData.title}">${pubData.title}</a></h3></li>
                                                </span>

                                                <div class="callout-box__content-description">
                                                    <div class="rich-text-content">
                                                        <@truncate text=object.summary.firstParagraph size="150" />
                                                    </div>
                                                    <div class="clearfix">
                                                        <p class="callout-box__content-description-date">${pubData.date}</p>
                                                    </div>

                                                    <#-- Make sure no supp info gets rendered twice -->
                                                    <#assign renderSuppinfo = false />
                                                    <#if object.supplementaryInformation?has_content>
                                                        <#list object.supplementaryInformation as suppInfo>
                                                            <#if !suppInfoList?seq_contains(suppInfo)>
                                                                <#assign renderSuppinfo = true />
                                                            </#if>
                                                        </#list>
                                                    </#if>

                                                    <#if renderSuppinfo>
                                                    <div class="inset-text">
                                                        <h3 class="inset-text__title"><@fmt.message key="headers.supplementary-information-requests" /></h3>
                                                        <ul class="inset-text__blocks">
                                                        <#list object.supplementaryInformation as suppInfo>
                                                            <#if !suppInfoList?seq_contains(suppInfo)>
                                                                <#assign suppInfoList += [suppInfo] />
                                                                <#if suppInfo.publishedDate??>
                                                                    <@fmt.formatDate var="suppInfoPublishDate" value=suppInfo.publishedDate.time?date type="date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />
                                                                </#if>

                                                                <li class="inset-text__block">
                                                                    <h4 class="inset-text__block-title"><a href="<@hst.link hippobean=suppInfo />">${suppInfo.title}</a> <#if suppInfo.publishedDate??><span>(${suppInfoPublishDate})</span></#if></h4>
                                                                    <div class="inset-text__block-content rich-text-content" itemprop="description">
                                                                        <@truncate text=suppInfo.shortsummary size="250" />
                                                                    </div>
                                                                </li>
                                                            </#if>
                                                        </#list>
                                                        </ul>
                                                    </div>
                                                    </#if>
                                                </div>
                                            </div>
                                        </div>
                                    </#if>
                            </#list>
                            </ul>
                        </div>
                    </#if>
                    <#-- [FTL-END] 'Past publications' section -->

                    <#-- [FTL-BEGIN] 'Attachments and Resource links' section -->
                    <#if hasResourceSection>
                    <div class="article-section" id="${slugify(resourcesSectionHeader)}">
                        <h2>${resourcesSectionHeader}</h2>
                        <ul data-uipath="ps.series.resources">
                        <#list series.attachments as attachment>
                            <li class="attachment" itemprop="hasPart" itemscope itemtype="http://schema.org/MediaObject">
                                <@externalstorageLink attachment.resource; url>
                                <a itemprop="contentUrl" title="${attachment.text}" href="${url}" onClick="logGoogleAnalyticsEvent('Download attachment','Series','${attachment.resource.filename}');" onKeyUp="return vjsu.onKeyUp(event)"><span itemprop="name">${attachment.text}</span></a>
                                </@externalstorageLink>
                                <@fileMetaAppendix attachment.resource.length, attachment.resource.mimeType></@fileMetaAppendix>
                            </li>
                        </#list>
                        <#list series.resourceLinks as link>
                            <li>
                                <a href="${link.linkUrl}" onClick="logGoogleAnalyticsEvent('Link click','Series','${link.linkUrl}');" onKeyUp="return vjsu.onKeyUp(event)" title="${link.linkText}">${link.linkText}</a>
                            </li>
                        </#list>
                        </ul>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Attachments and Resource links' section -->

                    <#-- [FTL-BEGIN] 'Administrative sources' section -->
                    <#if hasAdminSourcesSection>
                        <div class="article-section" id="administrative-sources">
                            <h2>${administrativeResourcesHeader}</h2>
                            <p itemprop="isBasedOn"
                               data-uipath="ps.series.administrative-sources">
                                ${document.administrativeSources}
                            </p>
                        </div>
                    </#if>
                    <#-- [FTL-END] 'Administrative sources' section -->

                    <#-- [FTL-BEGIN] 'Pre-release access' section -->
                    <#if hasPreReleaseAccessSection>
                    <div class="article-section" id="${slugify(preReleaseAccessSectionHeader)}">
                        <h2>${preReleaseAccessSectionHeader}</h2>

                        <ul class="list--reset">
                        <#list series.releaseSubjects as item>
                            <li>
                                <#if item.organisation?has_content>
                                    <h3>${item.organisation.title}</h3>
                                </#if>

                                <#if item.additionalDetail?? && item.additionalDetail.content?has_content>
                                <div class="rich-text-content">
                                    <@hst.html hippohtml=item.additionalDetail contentRewriter=gaContentRewriter />
                                </div>
                                </#if>

                                <#if item.recipients?has_content>
                                <ul>
                                <#list item.recipients as jobRole>
                                    <li>${jobRole.title}</li>
                                </#list>
                                </ul>
                            </li>
                            </#if>
                        </#list>
                        </ul>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Pre-release access' section -->

                    <#-- [FTL-BEGIN] 'Metadata' section -->
                    <#if hasMetadataSection>
                    <div class="article-section" id="${slugify(metadataSectionHeader)}">
                        <h2>${metadataSectionHeader}</h2>

                        <div class="detail-list-grid detail-list-grid--regular">
                            <#if series.issn?has_content>
                            <dl class="detail-list">
                                <dt class="detail-list__key"><@fmt.message key="labels.issn"/></dt>
                                <dd class="detail-list__value">${series.issn}</dd>
                            </dl>
                            </#if>
                            <#if series.refNumber?has_content>
                            <dl class="detail-list">
                                <dt class="detail-list__key"><@fmt.message key="labels.usrn"/></dt>
                                <dd class="detail-list__value">${series.refNumber?c}</dd>
                            </dl>
                            </#if>
                        </div>
                    </div>
                    </#if>
                    <#-- [FTL-END] 'Metadata' section -->
                </div>
            </div>
        </div>
    </div>
</article>

<#macro upcomingPublicationList>
<ul class="list list--reset cta-list" data-uipath="ps.series.publications-list.upcoming">
    <!--Only next 4 upcoming publications-->
    <#local count = (upcomingPublications?size < 4)?then(upcomingPublications?size, 4)/>
    <#list upcomingPublications[0..count-1] as publication>
    <li itemprop="hasPart" itemscope itemtype="http://schema.org/PublicationIssue">
        <#-- <@fmt.formatDate value=publication.nominalPublicationDateCalendar?date type="date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" /> -->
        <article class="cta">
            <h3 itemprop="name"><a href="<@hst.link hippobean=publication.selfLinkBean/>" title="${publication.title}" class="cta__button" itemprop="url">${publication.title}</a></h3>
            <p class="cta__text"><@formatRestrictableDate value=publication.nominalPublicationDate/></p>
        </article>
    </li>
    </#list>
</ul>
</#macro>

<#macro calloutBoxWebIcon>
    <svg class="callout-box__icon callout-box__icon--narrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
        <path d="M198,182H42c-6.6,0-12-5.4-12-12V74c0-6.6,5.4-12,12-12h156c6.6,0,12,5.4,12,12v96C210,176.6,204.6,182,198,182z"></path>
        <line x1="30" y1="92" x2="210" y2="92"></line>
        <line x1="60" y1="114" x2="180" y2="114"></line>
        <line x1="60" y1="135" x2="180" y2="135"></line>
        <line x1="60.1" y1="156" x2="141.1" y2="156"></line>
        <circle cx="46.8" cy="77.1" r="3.7"></circle>
        <circle cx="61.8" cy="77.1" r="3.7"></circle>
        <circle cx="76.8" cy="77.1" r="3.7"></circle>
        <rect x="166.2" y="149.1" width="13.8" height="13.8"></rect>
    </svg>
</#macro>
