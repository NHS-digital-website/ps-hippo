<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "component/infoGraphic.ftl">

<#macro fileInfographic mimeType = "">
    <#if mimeType != "">
        <#assign fileFormat = getFormatByMimeType(mimeType?lower_case) />
    </#if>
    <@infoGraphic />
</#macro>
