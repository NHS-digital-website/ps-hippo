<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro tabTileHeadings options type="page" area="">
    <#if options??>
        <div class="tab-group" data-uipath="ps.${type}-tabs">
            <ul class="tab-group__list" role="tablist">
                <#list options as option>
                    <#assign tab = slugify(option.tileSectionHeading) />
                    <#assign param = '?area='/>

                    <#if option.tileSectionLinks?has_content>
                        <li class="tab-group__list-item ${(area=='${tab}')?string("tab-group__list-item--active","")}">
                            <a class="tab-group__list-link" id="tab-${tab}" href="${param}${tab}" title="${option.tileSectionHeading} tab" role="tab">${option.tileSectionHeading}</a>
                        </li>
                    </#if>
                </#list>
            </ul>
        </div>
    </#if>
</#macro>
