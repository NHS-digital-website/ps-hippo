<#ftl output_format="HTML">

<#function buildIconPath id>
    <#local path = "" />

    <#if id = "down">
        <#local path = "<polygon points=\"15,8.5 13.5,7 9,11.2 9,1 7,1 7,11.2 2.5,7 1,8.5 8,15 \"/>" />
    <#elseif id = "up">
        <#local path = "<polygon points=\"1,7.5 2.5,9 7,4.8 7,15 9,15 9,4.8 13.5,9 15,7.5 8,1 \"/>" />
    <#elseif id = "right">
        <#local path = "<path d=\"M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z\"/>" />
    <#elseif id = "search">
        <#local path = "<path d=\"M7,10.9c-2.1,0-3.9-1.7-3.9-3.9c0-2.1,1.7-3.9,3.9-3.9c2.1,0,3.9,1.7,3.9,3.9C10.9,9.2,9.2,10.9,7,10.9zM13.4,14.8l1.4-1.4l-3-3c0.7-1,1.1-2.1,1.1-3.4c0-3.2-2.6-5.8-5.8-5.8C3.8,1.2,1.2,3.8,1.2,7c0,3.2,2.6,5.8,5.8,5.8c1.3,0,2.4-0.4,3.4-1.1L13.4,14.8z\"/>" />
    <#elseif id = "chevron-left">
        <#local path = "<path d=\"M4,8l6.5-7L12,2.5L6.8,8l5.3,5.5L10.5,15L4,8z\"/>" />
    <#elseif id = "chevron-up">
        <#local path = "<path d=\"M8,4l7,6.5L13.5,12L8,6.8L2.5,12L1,10.5L8,4z\"/>" />
    <#elseif id = "chevron-right">
        <#local path = "<path d=\"M12,8l-6.5,7L4,13.5L9.2,8L4,2.5L5.5,1L12,8z\"/>" />
    <#elseif id = "chevron-down">
        <#local path = "<path d=\"M8,12L1,5.5L2.5,4L8,9.2L13.5,4L15,5.5L8,12z\"/>" />
    </#if>
    <#return path />
</#function>

<#macro buildInlineSvg id size="m" modClass="">
    <span class="nhsd-a-icon nhsd-a-icon--size-${size} ${modClass}">
        <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
            <#if buildIconPath(id)?has_content>
                <@hst.html formattedText="${buildIconPath(id)}" />
            </#if>
        </svg>
    </span>
</#macro>
