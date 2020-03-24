<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro publicationHeader publication restricted=false downloadPDF=false earlyAccessKey="">
    <#assign informationTypes = publication.parentDocument?has_content?then(publication.parentDocument.informationType?has_content?then(publication.parentDocument.informationType, publication.informationType), publication.informationType) />
    <#assign fullTaxonomyList = publication.parentDocument?has_content?then(publication.parentDocument.fullTaxonomyList?has_content?then(publication.parentDocument.fullTaxonomyList, publication.fullTaxonomyList), publication.fullTaxonomyList) />
    <#assign geographicCoverage = publication.parentDocument?has_content?then(publication.parentDocument.geographicCoverage?has_content?then(publication.parentDocument.geographicCoverage, publication.geographicCoverage), publication.geographicCoverage) />
    <#assign granularity = publication.parentDocument?has_content?then(publication.parentDocument.granularity?has_content?then(publication.parentDocument.granularity, publication.granularity), publication.granularity) />

    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide">
        <div class="local-header article-header article-header--detailed">
            <div class="grid-wrapper">
                <div class="article-header__inner">

                    <@nationalStatsStamp publication=publication/>

                    <#if publication.parentDocument??>
                        <span class="article-header__label"><@fmt.message key="labels.publication"/>, Part of <a itemprop="url" href="<@hst.link hippobean=publication.parentDocument.selfLinkBean/>" title="${publication.parentDocument.title}"><span itemprop="name">${publication.parentDocument.title}</span></a></span>
                    <#else>
                        <span class="article-header__label"><@fmt.message key="labels.publication"/></span>
                    </#if>
                    <h1 class="local-header__title" data-uipath="document.title" itemprop="name">${publication.title}</h1>

                    <span data-uipath="ps.publication.information-types" class="article-header__types">
                        <#if publication.informationType?has_content>
                            <#list publication.informationType as type>${type}<#sep>, </#list>
                        </#if>
                    </span>

                    <div class="detail-list-grid">
                        <div class="grid-row">
                            <div class="column column--reset">
                                <dl class="detail-list">
                                    <dt class="detail-list__key"><@fmt.message key="headers.publication-date"/></dt>
                                    <dd class="detail-list__value" data-uipath="ps.publication.nominal-publication-date" itemprop="datePublished">
                                        <@formatRestrictableDate value=publication.nominalPublicationDate/>
                                    </dd>
                                </dl>
                            </div>
                        </div>

                        <#if !restricted>
                            <meta itemprop="keywords" content="${publication.fullTaxonomyList?join(",")}"/>

                            <#if publication.geographicCoverage?has_content>
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list">
                                            <dt class="detail-list__key" id="geographic-coverage"><@fmt.message key="headers.geographical-coverage"/></dt>
                                            <dd class="detail-list__value" itemprop="spatialCoverage" data-uipath="ps.publication.geographic-coverage">
                                                <#list publication.geographicCoverage as geographicCoverageItem>${geographicCoverageItem}<#sep>, </#list>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>

                            <#if publication.granularity?has_content >
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list">
                                            <dt class="detail-list__key"><@fmt.message key="headers.geographical-granularity"/></dt>
                                            <dd class="detail-list__value" data-uipath="ps.publication.granularity">
                                                <#list publication.granularity as granularityItem>${granularityItem}<#sep>, </#list>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>

                            <#if publication.coverageStart?? >
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list">
                                            <dt class="detail-list__key"><@fmt.message key="headers.date-range"/></dt>
                                            <dd class="detail-list__value" data-uipath="ps.publication.date-range">
                                                <#if publication.coverageStart?? && publication.coverageEnd??>
                                                    <@formatCoverageDates start=publication.coverageStart.time end=publication.coverageEnd.time/>
                                                    <meta itemprop="temporalCoverage" content="<@formatCoverageDates start=publication.coverageStart.time end=publication.coverageEnd.time schemaFormat=true/>" />
                                                <#else>
                                                    (Not specified)
                                                </#if>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>
                        </#if>

                        <#if downloadPDF>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <button type="button" class="cta-btn cta-btn--white top-margin-20 is-hidden-if-no-js" id="print-pdf-button"><@fmt.message key="labels.download-pdf"/></button>
                                </div>
                            </div>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <#if !restricted && publication.pageIndex?has_content>
        <div class="grid-wrapper grid-row grid-wrapper--article" data-uipath="ps.publication.pages">
            <#assign chunks=publication.pageIndex?chunk((publication.pageIndex?size/2)?ceiling)/>

            <div class="column column--one-half column--left">
                <ul class="list list--reset cta-list">
                    <#list chunks[0] as page>
                        <li itemprop="hasPart" itemscope itemtype="http://schema.org/WebPage">
                            <a itemprop="url" href="<@hst.link hippobean=page.linkedBean>
                                                        <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
                                                    </@hst.link>"
                               title="${page.title}"><span itemprop="name">${page.title}</span></a>
                        </li>
                    </#list>
                </ul>
            </div>
            <div class="column column--one-half column--right">
                <ul class="list list--reset ">
                    <#list chunks[1] as page>
                        <li itemprop="hasPart" itemscope itemtype="http://schema.org/WebPage">
                            <a itemprop="url" href="<@hst.link hippobean=page.linkedBean>
                                                        <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
                                                    </@hst.link>"
                               title="${page.title}"><span itemprop="name">${page.title}</span></a>
                        </li>
                    </#list>
                </ul>
            </div>
        </div>
    </#if>
</#macro>

<#macro nationalStatsStamp publication>
    <#if publication.informationType??>
        <#list publication.informationType as type>
            <#if type == "National statistics">
                <div class="article-header__stamp" data-uipath="ps.publication.national-statistics">
                    <img src="<@hst.webfile path="images/national-statistics-logo.svg"/>" data-uipath="ps.publication.national-statistics" alt="National Statistics" title="National Statistics" class="image-icon image-icon--large" />
                </div>
                <#break>
            </#if>
        </#list>
    </#if>
</#macro>
