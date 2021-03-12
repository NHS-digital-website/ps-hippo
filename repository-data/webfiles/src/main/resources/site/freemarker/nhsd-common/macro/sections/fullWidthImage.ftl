<#ftl output_format="HTML">

<#macro fullWidthImageSection section>
    <@hst.link hippobean=section.largeImage.original fullyQualified=true var="largeImage" />
    <@hst.link hippobean=section.smallImage.original fullyQualified=true var="smallImage" />
    <figure class="full-width-image">
        <picture>
            <#if smallImage?is_string && smallImage?length gt 0>
                <source srcset="${smallImage}" media="(max-width: 960px)"/>
            </#if>
            <img src="${largeImage}" alt="${section.altText}">
        </picture>
        <#if section.title?is_string && section.title?length gt 0>
            <figcaption class="full-width-image__caption">${section.title}</figcaption>
        </#if>
    </figure>
</#macro>
