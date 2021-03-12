<#ftl output_format="HTML">

<#macro imageSection section>
    <div data-uipath="ps.publication.image-section">

        <#assign link = section.link />
        <#if section.link?has_content && ! section.link?starts_with("http") >
          <#assign link = "http://" + section.link />
        </#if>

        <#if link?has_content><a href="${link}" data-uipath="ps.publication.image-section.link"></#if>
            <figure>
                <img src="<@hst.link hippobean=section.image/>"
                     alt="${section.altText}"
                     data-uipath="ps.publication.image-section.image"
                     <#if section.size??>style="width:100%;"</#if>
                />
                <#if section.caption?has_content>
                    <figcaption data-uipath="ps.publication.image-section.caption">
                        ${section.caption}
                    </figcaption>
                </#if>
            </figure>
        <#if section.link?has_content></a></#if>
    </div>
</#macro>
