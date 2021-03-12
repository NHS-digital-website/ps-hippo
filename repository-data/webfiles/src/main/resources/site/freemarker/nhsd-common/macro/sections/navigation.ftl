<#ftl output_format="HTML">
<#include "navigationTile.ftl">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Navigation" -->
<#macro navigation section>
    <#local imageType = section.imageType />
    <#local tileType = section.columnAlignment />

    <#local headingClass = (section.headingLevel?has_content && section.headingLevel == 'Main heading')?then('article-section', 'article-header__detail-lines') />

<div id="${slugify(section.heading)}"
     class="navigation-section navigation-section--${tileType} navigation-section--${imageType} ${headingClass}">

    <#if section.headingLevel?has_content && section.headingLevel == 'Main heading'>
        <#local mainHeadingTag = "h2" />
        <${mainHeadingTag}>${section.title}</${mainHeadingTag}>
    <#else>
        <#local subHeadingTag = "h3" />
        <${subHeadingTag}>${section.title}</${subHeadingTag}>
    </#if>

    <div class="navigation-section__introduction">
        <@hst.html hippohtml=section.sectionIntroduction contentRewriter=gaContentRewriter />
    </div>

    <div class="navigation-section__tiles">
        <#list section.navigationTiles as tile>
            <@navigationTile tile tileType imageType />
        </#list>
    </div>
</div>
</#macro>
