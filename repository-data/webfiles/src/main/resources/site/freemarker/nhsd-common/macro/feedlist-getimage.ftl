<#ftl output_format="HTML">

<#function getImageData feedItem>
    <#local image = '' />
    <#local alttext = '' />
    <#if (feedItem.leadimagesection)?has_content && (feedItem.leadimagesection.leadImage)?has_content>
        <#local image = feedItem.leadimagesection.leadImage />
        <#local alttext = feedItem.leadimagesection.alttext />
    <#elseif (feedItem.leadImage)?has_content>
        <#local image = feedItem.leadImage />
        <#local alttext = feedItem.leadImageAltText />
    <#elseif feedItem.summaryimage?? && feedItem.summaryimage.original?? >
        <#local image = feedItem.summaryimage />
        <#local alttext = feedItem.title />
    </#if>
    <#return [image, alttext] />
</#function>
