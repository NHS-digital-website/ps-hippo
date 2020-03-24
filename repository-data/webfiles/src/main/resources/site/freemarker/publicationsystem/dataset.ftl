<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/structured-text.ftl">
<#include "../common/macro/fileMetaAppendix.ftl">
<#include "../common/macro/contentPixel.ftl">
<#include "../common/macro/contentPixel.ftl">
<@hst.setBundle basename="publicationsystem.labels,publicationsystem.headers"/>

<#-- Add meta tags -->
<#include "../common/macro/metaTags.ftl">
<@metaTags></@metaTags>

<article class="article article--dataset" aria-label="Document Header">
<#if dataset??>

<#-- Content Page Pixel -->
<@contentPixel dataset.getCanonicalUUID() dataset.title></@contentPixel>

<#assign hasPublicationDate = dataset.nominalDate?has_content />
<#assign hasNextPublicationDate = dataset.nextPublicationDate?has_content />
<#assign hasBothPublicationDates = hasPublicationDate && hasNextPublicationDate />
<#assign hasGeographicCoverage = dataset.geographicCoverage?has_content />
<#assign hasGranularity = dataset.granularity?has_content />

<#assign hasFiles = dataset.files?has_content />
<#assign hasResourceLinks = dataset.resourceLinks?has_content />
<#assign hasResources = hasFiles || hasResourceLinks />

<#assign earlyAccessKey=hstRequest.request.getParameter("key") />

<#macro publicationDate>
<dl class="detail-list">
    <dt class="detail-list__key"><@fmt.message key="headers.publication-date"/></dt>
    <dd class="detail-list__value" data-uipath="ps.dataset.nominal-date" itemprop="datePublished">
        <@formatRestrictableDate value=dataset.nominalDate/>
    </dd>
</dl>
</#macro>

<#macro nextPublicationDate>
<dl class="detail-list">
    <dt class="detail-list__key"><@fmt.message key="headers.next-publication-date"/></dt>
    <dd class="detail-list__value" data-uipath="ps.dataset.next-publication-date">
        <@formatDate date=dataset.nextPublicationDate.time/>
    </dd>
</dl>
</#macro>

    <div itemscope itemtype="http://schema.org/Dataset">
        <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide" data-uipath="ps.document.content">
            <div class="local-header article-header article-header--detailed">
                <div class="grid-wrapper">
                    <div class="article-header__inner">
                        <meta itemprop="keywords" content="${dataset.fullTaxonomyList?join(",")}"/>
                        <#assign thisurl="<@hst.link hippobean=dataset.selfLinkBean/>"/>
                        <meta itemprop="url" content="<@hst.link hippobean=dataset.selfLinkBean/>"/>
                        <meta itemprop="license" content="https://digital.nhs.uk/about-nhs-digital/terms-and-conditions" />
                        <#if dataset.parentPublication??>
                            <span class="article-header__label">
                                <@fmt.message key="labels.dataset"/>,
                                Part of
                                <a itemprop="url"
                                   title="${dataset.parentPublication.title}"
                                   href=<@hst.link hippobean=dataset.parentPublication.selfLinkBean>
                                    <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
                                    </@hst.link>"
                                   >
                                    <span itemprop="name">${dataset.parentPublication.title}</span>
                                </a>
                            </span>
                        <#else>
                            <span class="article-header__label"><@fmt.message key="labels.dataset"/></span>
                        </#if>
                        <h1 class="local-header__title" data-uipath="document.title" itemprop="name">${dataset.title}</h1>

                        <div class="detail-list-grid">
                            <div class="grid-row">
                                <div class="column column--one-half column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"><@fmt.message key="headers.date-range"/></dt>
                                        <dd class="detail-list__value" data-uipath="ps.dataset.date-range">
                                            <#if dataset.coverageStart?? && dataset.coverageEnd??>
                                                <@formatCoverageDates start=dataset.coverageStart.time end=dataset.coverageEnd.time/>
                                                <meta itemprop="temporalCoverage" content="<@formatCoverageDates start=dataset.coverageStart.time end=dataset.coverageEnd.time schemaFormat=true/>" />
                                            <#else>
                                                (Not specified)
                                            </#if>
                                        </dd>
                                    </dl>
                                </div>

                                <#if hasPublicationDate && !hasBothPublicationDates>
                                    <div class="column column--one-half column--reset">
                                        <@publicationDate />
                                    </div>
                                </#if>
                            </div>

                            <#if hasBothPublicationDates>
                            <div class="grid-row">
                                <div class="column column--one-half column--reset">
                                    <@publicationDate />
                                </div>

                                <div class="column column--one-half column--reset">
                                    <@nextPublicationDate />
                                </div>
                            </div>
                            </#if>

                            <#if hasGeographicCoverage>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key" id="geographic-coverage" data-uipath="geographic-coverage"><@fmt.message key="headers.geographical-coverage"/></dt>
                                        <dd class="detail-list__value" data-uipath="ps.dataset.geographic-coverage">
                                            <#list dataset.geographicCoverage as geographicCoverageItem>
                                            <span itemprop="spatialCoverage" itemscope itemtype="http://schema.org/Place"><span itemprop="name">${geographicCoverageItem}</span></span><#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                            </#if>

                            <#if hasGranularity>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"><@fmt.message key="headers.geographical-granularity"/></dt>
                                        <dd class="detail-list__value" data-uipath="ps.dataset.granularity">
                                            <#list dataset.granularity as granularityItem>${granularityItem}<#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="grid-wrapper grid-wrapper--article" aria-label="Document Content">
            <div class="grid-row">
                <div class="column column--two-thirds page-block page-block--main">
                    <div class="article-section">
                        <h2><@fmt.message key="headers.summary"/></h2>
                        <div class="rich-text-content" itemprop="description">
                            <@structuredText item=dataset.summary uipath="ps.dataset.summary" />
                        </div>
                    </div>

                    <#if hasResources>
                    <div class="article-section">
                        <h2><@fmt.message key="headers.resources"/></h2>
                        <ul data-uipath="ps.dataset.resources" class="list">
                            <#list dataset.files as attachment>
                                <li class="attachment" itemprop="distribution" itemscope itemtype="http://schema.org/DataDownload">
                                    <@externalstorageLink item=attachment.resource earlyAccessKey=earlyAccessKey; url>
                                      <a itemprop="contentUrl" title="${attachment.text}" href="${url}" onClick="logGoogleAnalyticsEvent('Download attachment','Data set','${attachment.resource.filename}');" onKeyUp="return vjsu.onKeyUp(event)"><span itemprop="name">${attachment.text}</span></a>
                                      <meta itemprop="license" content="https://digital.nhs.uk/about-nhs-digital/terms-and-conditions" />
                                      <meta itemprop="encodingFormat" content="${attachment.resource.mimeType}" />
                                      <meta itemprop="name" content="${attachment.text}" />
                                    </@externalstorageLink>
                                    <@fileMetaAppendix attachment.resource.length, attachment.resource.mimeType></@fileMetaAppendix>
                                </li>
                            </#list>
                            <#list dataset.resourceLinks as link>
                                <li>
                                    <a href="${link.linkUrl}" onClick="logGoogleAnalyticsEvent('Link click','Data set','${link.linkUrl}');" onKeyUp="return vjsu.onKeyUp(event)">${link.linkText}</a>
                                </li>
                            </#list>
                        </ul>
                    </div>
                    </#if>
                </div>
            </div>
        </div>
    </div>

<#else>
    <div class="grid-wrapper grid-wrapper--article" aria-label="Document Content">
        <div class="grid-row">
            <div class="column column--two-thirds page-block page-block--main">
                <div class="article-section">
                    <span>${error}</span>
                </div>
            </div>
        </div>
    </div>
</#if>

</article>
