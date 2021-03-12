<#ftl output_format="HTML">

<#-- @ftlvariable name="document" type="uk.nhs.digital.website.beans.General" -->

<#include "../include/imports.ftl">
<#include "macro/sections/sections.ftl">
<#include "macro/documentHeader.ftl">
<#include "macro/stickyNavSections.ftl">
<#include "macro/furtherInformationSection.ftl">
<#include "macro/metaTags.ftl">
<#include "macro/component/lastModified.ftl">
<#include "macro/latestblogs.ftl">
<#include "macro/component/calloutBox.ftl">
<#include "macro/contentPixel.ftl">
<#-- Add meta tags -->
<@metaTags></@metaTags>

<#if document.metadata?has_content>
    <#list document.metadata as md>
        <@hst.headContribution category="metadata">
            ${md?no_esc}
        </@hst.headContribution>
    </#list>
</#if>

<@hst.setBundle basename="rb.generic.headers,publicationsystem.headers"/>

<#assign hasSummaryContent = document.summary.content?has_content />
<#assign hasSectionContent = document.sections?has_content />
<#assign hasChildPages = childPages?has_content />
<#assign hasHtmlCode = document.htmlCode?has_content />
<#assign sectionTitlesFound = countSectionTitles(document.sections) />
<#assign renderNav = ((hasSummaryContent || hasChildPages) && sectionTitlesFound gte 1) || sectionTitlesFound gt 1 || (hasSummaryContent && hasChildPages) />
<#assign idsuffix = slugify(document.title) />
<#assign navStatus = document.navigationController />
<#assign hasBannerImage = document.image?has_content />
<#assign custom_summary = document.summary />

<#-- Content Page Pixel -->
<@contentPixel document.getCanonicalUUID() document.title></@contentPixel>

<article class="article article--general">
    <#if hasBannerImage>
        <@hst.link hippobean=document.image.original fullyQualified=true var="bannerImage" />
        <div class="banner-image" aria-label="Document Header"
             style="background-image: url(${bannerImage});">
            <div class="grid-wrapper">
                <div class="grid-row">
                    <div class="column column--reset banner-image-title">
                        <div class="banner-image-title-background">
                            <h1 data-uipath="document.title">${document.title}</h1>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <#else>
        <@documentHeader document 'general'></@documentHeader>
    </#if>
    <div class="grid-wrapper grid-wrapper--article">
        <#if document.updates?has_content>
            <div class="grid-row">
                <div class="column column--no-padding">
                    <div class="callout-box-group">
                        <#assign item = {} />
                        <#list document.updates as update>
                            <#assign item += update />
                            <#assign item += {"calloutType":"update", "index":update?index} />
                            <@calloutBox item />
                        </#list>
                    </div>
                </div>
            </div>
        </#if>
        <div class="grid-row">
            <#if navStatus == "withNav" && renderNav>
                <div class="column column--one-third page-block--sticky-nav page-block--sidebar article-section-nav-outer-wrapper">
                    <!-- start sticky-nav -->
                    <div id="sticky-nav">
                        <#assign links = [{ "url": "#top", "title": "Top of page" }] />
                        <#if document.latestNews?has_content >
                            <#assign links += [{ "url": "#related-articles-latest-news-${idsuffix}", "title": 'Latest news' }] />
                        </#if>
                        <#assign links += getStickySectionNavLinks({ "document": document, "childPages": childPages, "includeTopLink": false }) />
                        <#if document.relatedEvents?has_content >
                            <#assign links += [{ "url": "#related-articles-events-${idsuffix}", "title": 'Forthcoming events' }] />
                        </#if>
                        <@stickyNavSections links></@stickyNavSections>
                    </div>
                    <!-- end sticky-nav -->
                    <#-- Restore the bundle -->
                    <@hst.setBundle basename="rb.generic.headers,publicationsystem.headers"/>
                </div>
            </#if>

            <div class="column ${(navStatus == "withNav" || navStatus == "withoutNav")?then("column--two-thirds", "column--wide-mode")} page-block page-block--main">
                <#if hasBannerImage>
                    <#if hasSummaryContent>
                        <div class="article-header__subtitle"
                             data-uipath="website.general.summary">
                            <@hst.html hippohtml=custom_summary contentRewriter=gaContentRewriter/>
                        </div>
                    </#if>
                </#if>
                <@latestblogs document.latestNews 'General' 'latest-news-' + idsuffix 'Latest news' />

                <#if hasSectionContent>
                    <@sections document.sections></@sections>
                </#if>

                <#if !document.latestNews?has_content && document.relatedNews?has_content >
                    <@latestblogs document.relatedNews 'General' 'related-news-' + idsuffix 'Related news' />
                </#if>

                <#if hasChildPages>
                    <@furtherInformationSection childPages></@furtherInformationSection>
                </#if>

                <@latestblogs document.relatedEvents 'General' 'events-' + idsuffix 'Forthcoming events' />

                <div class="article-section muted">
                    <@lastModified document.lastModified false></@lastModified>
                </div>
            </div>
        </div>
    </div>
</article>

<#if hasHtmlCode>
    ${document.htmlCode?no_esc}
</#if>
