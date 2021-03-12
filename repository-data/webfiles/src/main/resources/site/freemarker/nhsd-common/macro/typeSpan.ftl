<#ftl output_format="HTML">

<#macro typeSpan type>
    <#if type?? && (type == "external" || type == "internal" || type == "asset") >
        <span class="type-span type-span--${type} type-span--hidden" data-type="${type}">${type}</span>
    </#if>
</#macro>