<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">

<#macro nationalStatsStamp document>
    <#if (document.informationType)?has_content>
        <#list document.informationType as type>
            <#if type == "National statistics">
                <div class="article-header__stamp">
                    <img src="<@hst.webfile path="images/national-statistics-logo.svg"/>"
                         alt="A logo for National Statistics"
                         title="National Statistics"
                         class="image-icon image-icon--large"/>
                </div>
                <#break>
            </#if>
        </#list>
    </#if>
</#macro>

<#macro publicationDate document>
    <dl class="detail-list">
        <dt class="detail-list__key"><@fmt.message key="labels.publication-date"/>
            :
        </dt>
        <dd class="detail-list__value" data-uipath="ps.dataset.nominal-date"
            itemprop="datePublished">
            <@fmt.formatDate value=document.publicationDate.time?date type="date" pattern="d MMM yyyy" timeZone="${getTimeZone()}" />
        </dd>
    </dl>
</#macro>

<#macro textBanner document topTitle="">
    <#local hasGeographicCoverage = document.geographicCoverage?has_content />
    <#local hasGranularity = document.geographicGranularity?has_content />
    <#local hasPublicationDate = document.publicationDate?? />

    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide">
        <div class="local-header article-header article-header--detailed">
            <div class="grid-wrapper">
                <div class="article-header__inner">

                    <@nationalStatsStamp document />

                    <#if topTitle?is_string && topTitle?length gt 0>
                        <span>${topTitle}</span>
                    </#if>

                    <h1 class="local-header__title"
                        data-uipath="document.title">${document.title}</h1>

                    <#-- TODO - Chapter title to be added  -->
                    <#-- <p class="article-header__subtitle">(Hardcoded) Chapter title</p> -->

                    <span data-uipath="ps.publication.information-types">
                        <#if (document.informationType)?has_content>
                            <#list document.informationType as type>${type}<#sep>, </#list>
                        </#if>
                    </span>

                    <div class="detail-list-grid">
                        <#if hasPublicationDate>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <@publicationDate document />
                                </div>
                            </div>
                        </#if>

                        <#if hasGeographicCoverage>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"
                                            id="geographic-coverage"><@fmt.message key="labels.geographic-coverage"/>
                                            :
                                        </dt>
                                        <dd class="detail-list__value">
                                            <#list document.geographicCoverage as geographicCoverageItem>${geographicCoverageItem}<#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </#if>

                        <#if hasGranularity>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"><@fmt.message key="labels.geographic-granularity"/>
                                            :
                                        </dt>
                                        <dd class="detail-list__value">
                                            <#list document.geographicGranularity as granularityItem>${granularityItem}<#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </#if>

                        <#if document.coverageStart??>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"><@fmt.message key="labels.date-range"/>
                                            :
                                        </dt>
                                        <dd class="detail-list__value">
                                            <#if document.coverageStart?? && document.coverageEnd??>
                                                <@formatCoverageDates start=document.coverageStart.time end=document.coverageEnd.time/>
                                            <#else>
                                                (Not specified)
                                            </#if>
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
</#macro>
