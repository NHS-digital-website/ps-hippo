<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<@hst.setBundle basename="month-names"/>

<#if facets??>
    <#list facets.folders as facet>
        <div class="article-section-nav-wrapper faceted-nav-facet">
            <div class="article-section-nav">
                <h2 class="article-section-nav__title">Filter by ${facet.name}</h2>
                <nav>
                    <ol class="article-section-nav__list">
                        <#list facet.folders as value>
                            <#if value.count &gt; 0>
                                <li>
                                    <#assign affix = query?has_content?then("?query=" + query, "") />
                                    <#assign valueName = value.name />
                                    <#if facet.name="month">
                                        <@fmt.message key=value.name var="monthName"/>
                                        <#assign valueName=monthName/>
                                    </#if>
                                    <#if value.leaf>
                                        <@hst.facetnavigationlink var="link" remove=value current=facets />
                                        <#if facet.name="year">
                                                <a href="${link?replace('month/(?:[0-9]|1[0-1])/?', '', 'ir')}" class="tag-link selected">${valueName} (${value.count})</a>
                                            <#else>
                                                <a href="${link}" class="tag-link selected">${valueName} (${value.count})</a>
                                        </#if>
                                    <#else>
                                        <@hst.link var="link" hippobean=value />
                                        <a href="${link + affix}" class="tag-link">${valueName}&nbsp;(${value.count})</a>
                                    </#if>
                                </li>
                            </#if>
                        </#list>
                    </ol>
                </nav>
            </div>
        </div>
    </#list>
</#if>
