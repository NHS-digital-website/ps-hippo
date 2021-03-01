<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "../macro/sections/statistic.ftl">
<#include "../macro/iconGenerator.ftl">
<#include "../macro/gridColumnGenerator.ftl">

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<div class="nhsd-o-graphic-block-list nhsd-!t-margin-bottom-9">
    <div class="nhsd-t-grid nhsd-!t-no-gutters">
        <div class="nhsd-t-row nhsd-t-row--centred nhsd-o-graphic-block-list__items">
            <#if pageable?? && pageable.items?has_content>
                <#list pageable.items as item>
                    <#assign hasLinks = item.items?has_content />
                    <#assign hasStats = item.modules?has_content />
                    <#assign hasImage = item.image?has_content />
                    <#assign colOffset = pageable.items?size == 4 && item?is_even_item />

                    <div class="nhsd-t-col-xs-12 ${getGridCol(pageable.items?size, "small", colOffset)}">
                        <div class="nhsd-m-graphic-block">
                            <#if hasImage>
                                <#assign altText = item.altText?has_content?then(item.altText, "image for graphic block ${item?index}") />
                                <@hst.link hippobean=item.image fullyQualified=true var="graphicImage" />

                                <div class="nhsd-m-graphic-block__picture">
                                    <figure class="nhsd-a-image nhsd-a-image--square">
                                        <picture class="nhsd-a-image__picture">
                                            <img src="${graphicImage}" alt="${altText}">
                                        </picture>
                                    </figure>
                                </div>
                            </#if>

                            <#if hasStats>
                                <#assign stats = item.modules[0] />

                                <div class="nhsd-m-graphic-block__heading">
                                    <#assign hasNumber = stats.number?has_content />
                                    <#if hasNumber>
                                        <span class="nhsd-t-heading-xl nhsd-!t-margin-bottom-0">${getPrefix(stats.prefix)}${stats.number}${getSuffix(stats.suffix)}
                                            <#if stats.trend != "none">
                                                <@buildInlineSvg stats.trend />
                                            </#if>
                                        </span>
                                    </#if>

                                    <@hst.html hippohtml=stats.headlineDescription var="headlineDesc"/>
                                    <#assign hasHeadline = headlineDesc?has_content />
                                    <#if hasHeadline>
                                        <span class="nhsd-t-heading-xs">${headlineDesc?replace('<[^>]+>','','r')}</span>
                                    </#if>
                                </div>

                                <@hst.html hippohtml=stats.furtherQualifyingInformation var="furtherQualInfo"/>
                                <#assign hasQualInfo = furtherQualInfo?has_content />
                                <#if hasQualInfo>
                                    <p class="nhsd-t-body-s">${furtherQualInfo?replace('<[^>]+>','','r')}</p>
                                </#if>

                                <#if hasLinks>
                                    <div class="nhsd-!t-margin-top-3 nhsd-!t-margin-bottom-3">
                                        <#assign link = item.items[0] />

                                        <#if link.linkType == "internal">
                                            <#assign linkLabel = link.link.title />
                                            <a href="<@hst.link hippobean=link.link/>" class="nhsd-a-link nhsd-t-body-s">
                                        <#else>
                                            <#assign linkLabel = link.title />
                                            <a href="${link.link}" class="nhsd-a-link nhsd-t-body-s" target="_blank" rel="external">
                                        </#if>

                                        <span class="nhsd-a-link__label nhsd-t-body-s">${linkLabel}</span>

                                        <#if link.linkType == "external">
                                            <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                                        </#if>
                                        </a>
                                    </div>
                                </#if>
                            </#if>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>
    </div>
</div>
