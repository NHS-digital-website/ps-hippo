<#ftl output_format="HTML">

<#include 'statistic.ftl'>

<#macro statistics section>
    <#local heading = section.heading />
    <#local colourScheme = section.colourScheme />
    <#local animated = section.animation />

    <#if section.headingLevel?has_content && section.headingLevel == 'Main heading'>
        <#local headingTag = "h2" />
    <#else>
        <#local headingTag = "h3" />
    </#if>

    <#if colourScheme == 'boldtakeover' && (section.modules?size >= 3)>
        <#local sizeClass = 'statistics-section--wide' >
    <#else>
        <#local sizeClass = '' >
    </#if>
    <#local colourClass = "statistics-section--${colourScheme}" />
    <#local animatedClass = "statistics-section--${animated}" />
    <#local containerClasses = ["statistics-section", colourClass, animatedClass, sizeClass] />
    <div class="${containerClasses?join(' ')}">
        <#if section.heading?has_content>
            <${headingTag} id="${slugify(heading)}" class="statistics-section__heading">${heading}</${headingTag}>
        </#if>
        <#list section.modules >
            <div class="statistics-section__modules">
                <#items as stat>
                    <@statistic stat stat?item_cycle('1', '2', '3', '4')/>
                </#items>
            </div>
        </#list>
    </div>
</#macro>
