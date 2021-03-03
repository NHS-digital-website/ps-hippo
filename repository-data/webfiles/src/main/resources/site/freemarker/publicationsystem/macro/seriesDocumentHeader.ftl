<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#-- Big Blue document header for Series -->
<#macro seriesDocumentHeader document>
    <#assign informationTypes = (series.informationType??)?then(series.informationType, [])  />
    <#assign frequency = (series.frequency?has_content)?then(series.frequency, "") />
    <#assign geographicCoverage = (series.geographicCoverage?has_content)?then(series.geographicCoverage, []) />
    <#assign granularity = (series.granularity??)?then(series.granularity, []) />
    <#assign fullTaxonomyList = series.fullTaxonomyList />

    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide">
        <div class="local-header article-header article-header--detailed" aria-label="Series Title">
            <div class="grid-wrapper">
                <div class="article-header__inner">
                    <span class="article-header__label"><@fmt.message key="labels.series"/></span>
                    <h1 class="local-header__title" data-uipath="document.title" itemprop="name">${document.title}</h1>

                    <#if series.informationType?has_content>
                        <span class="article-header__types article-header__types--push" data-uipath="ps.series.information-types">
                            <#list series.informationType as type>${type}<#sep>, </#list>
                        </span>
                        <hr class="hr hr--short hr--light">
                    </#if>

                    <div class="detail-list-grid">
                        <#if frequency?has_content>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key" id="frequency"><@fmt.message key="headers.frequency"/></dt>
                                        <dd class="detail-list__value" itemprop="frequency" data-uipath="ps.series.frequency">${frequencyMap[frequency]}</dd>
                                    </dl>
                                </div>
                            </div>
                        </#if>

                        <#if geographicCoverage?has_content>
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key" id="geographic-coverage"><@fmt.message key="headers.geographical-coverage"/></dt>
                                        <dd class="detail-list__value" itemprop="spatialCoverage" data-uipath="ps.series.geographic-coverage">
                                            <#list geographicCoverage as geographicCoverageItem>${geographicCoverageItem}<#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </#if>

                        <#if granularity?has_content >
                            <div class="grid-row">
                                <div class="column column--reset">
                                    <dl class="detail-list">
                                        <dt class="detail-list__key"  id="geographical-granularity"><@fmt.message key="headers.geographical-granularity"/></dt>
                                        <dd class="detail-list__value" data-uipath="ps.series.granularity">
                                            <#list granularity as granularityItem>${granularityItem}<#sep>, </#list>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </#if>
                    </div>

                    <#if fullTaxonomyList?has_content>
                        <meta itemprop="keywords" content="${fullTaxonomyList?join(",")}"/>
                    </#if>
                </div>
            </div>
        </div>
    </div>
</#macro>
