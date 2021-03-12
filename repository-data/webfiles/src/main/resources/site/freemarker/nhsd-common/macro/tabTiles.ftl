<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro tabTiles options>
    <#if options??>
        <#if options.title??>
            <#assign title = options.title>
        </#if>
        <#if options.summary??>
            <#assign summary = options.summary>
        </#if>

        <#if options.linkType == "internal">
            <#assign title = options.link.title>
        <#elseif options.linkType == "external">
            <#assign summary = options.shortsummary>
        </#if>

        <div class="tile-panel-group__item">
            <div class="tile-panel-group__item-content">
                <h2>
                    <#if options.linkType == "internal">
                    <a href="<@hst.link hippobean=options.link />">
                        <#elseif options.linkType == "external">
                        <a href="${options.link}">
                            </#if>
                            ${title}
                        </a>
                </h2>
                <p>${summary}</p>
            </div>
        </div>
    </#if>
</#macro>
