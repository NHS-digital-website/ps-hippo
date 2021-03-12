<#ftl output_format="HTML">

<#macro icon name="default" size="default">
    <#if (size??)>
        <#assign sizeClass = " icon--${size}" />
    </#if>
    <span class="icon icon--${name}${sizeClass}" aria-hidden="true"></span>
</#macro>
