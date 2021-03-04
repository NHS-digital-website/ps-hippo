<#ftl output_format="HTML">

<#macro trendingArticleImage trending>

    <figure class="nhsd-a-image">
        <picture class="nhsd-a-image__picture ">
            <source media="(max-width: 500px)" srcset="https://digital.nhs.uk/binaries/content/gallery/website/about-nhs-digital/fibre_57101102_med.jpg">
            <#if trending.docType == 'NewsInternal'>
                <#if trending.leadImageSection?? && trending.leadImageSection.leadImage?? && trending.leadImageSection.leadImage.original??>
                    <img src="<@hst.link hippobean=trending.leadImageSection.leadImage.original/>"
                            <#if trending.leadImageSection.alttext?? && trending.leadImageSection.alttext?has_content>
                                alt="${trending.leadImageSection.alttext}"
                            <#else>
                                alt="${trending.title} Image"
                            </#if>
                        aria-hidden="true">

                <#else>
                    <img src="<@hst.webfile path="images/fibre_57101102_med.jpg"/>"
                        alt="${trending.title} Image"
                        aria-hidden="true">
                </#if>

            <#elseif trending.docType == 'Blog'>
                <#if trending.leadImage?? && trending.leadImage.original??>
                    <img src="<@hst.link hippobean=trending.leadImage.original/>"
                            <#if trending.leadImageAltText?? && trending.leadImageAltText?has_content>
                                alt="${trending.leadImageAltText}"
                            <#else>
                                alt="${trending.title} Image"
                            </#if>
                        aria-hidden="true">
                <#else>
                    <img src="<@hst.webfile path="images/fibre_57101102_med.jpg"/>"
                        alt="${trending.title} Image"
                        aria-hidden="true">
                </#if>

            <#elseif trending.docType == 'Announcement'>
                <img src="<@hst.webfile path="images/fibre_57101102_med.jpg"/>"
                    alt="${trending.title} Image"
                    aria-hidden="true">
            </#if>

        </picture>
    </figure>
</#macro>
