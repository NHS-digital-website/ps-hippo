<#ftl output_format="HTML">

<#include "component/icon.ftl">

<#macro fileIconByFileType link>
    <#if link?matches("(?mi)^https?://[^/]+?/.+\\.[a-z]{3,4}$")>
        <#assign fileFormat = link?replace("^(?i).*\\.([a-z]{3,4})$", "$1", "r") />
    <#else>
        <#assign fileFormat = "html" />
    </#if>
    <@icon name="${fileFormat?lower_case}" size="download" />
</#macro>
