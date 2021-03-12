<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "component/icon.ftl">

<#macro fileIconByMimeType mimeType = "">
    <#if mimeType != "">
        <#assign fileFormat = getFormatByMimeType(mimeType?lower_case) />
    </#if>
    <@icon name="${fileFormat}" size="download" />
</#macro>
