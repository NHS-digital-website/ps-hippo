<#ftl output_format="HTML">

<#macro lastModified datetime chrome=true label="Last edited: " >
    <#setting time_zone="GMT">
    <#assign output>${label}${datetime?string["d MMMM yyyy h:mm a"]?replace("AM", "am")?replace("PM", "pm")}</#assign>
    <#if chrome>
        <div class="article-section muted no-border no-top-padding" id="last-edited">
            ${output}
        </div>
    <#else>
        ${output}
    </#if>
</#macro>
