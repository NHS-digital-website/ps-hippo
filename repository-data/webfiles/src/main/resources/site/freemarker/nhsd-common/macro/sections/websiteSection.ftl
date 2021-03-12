<#ftl output_format="HTML">

<#macro websiteSection section isPreviousSectionEmphasisBox numberedListCount mainHeadingLevel=2 >
    <#assign articleSectionClass = 'article-section navigationMarker' />
    <#assign subHeading = section.headingLevel?has_content && section.headingLevel == 'Sub heading'/>
    <#if subHeading>
        <#assign articleSectionClass = 'article-section-with-sub-heading navigationMarker-sub' />
    </#if>

    <#if section.title?has_content>
        <div id="${slugify(section.title)}" class="${articleSectionClass} <#if isPreviousSectionEmphasisBox>article-section--highlighted</#if>">
            <h${subHeading?then(mainHeadingLevel?int + 1, mainHeadingLevel)} data-uipath="website.contentblock.section.title"><#if section.isNumberedList>${numberedListCount}. </#if>${section.title}</h${subHeading?then(mainHeadingLevel?int + 1, mainHeadingLevel)}>
            <div data-uipath="website.contentblock.section.content" class="rich-text-content">
                <@hst.html hippohtml=section.html contentRewriter=gaContentRewriter/>
            </div>
        </div>
    <#else>
        <div class="article-section-with-no-heading">
            <div data-uipath="website.contentblock.section.content" class="rich-text-content">
                <@hst.html hippohtml=section.html contentRewriter=gaContentRewriter/>
            </div>
        </div>
    </#if>
</#macro>
