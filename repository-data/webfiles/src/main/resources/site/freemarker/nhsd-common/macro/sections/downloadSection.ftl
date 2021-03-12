<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Download" -->

<#include "../fileIconByMimeType.ftl">
<#include "../fileIconByFileType.ftl">
<#include "../fileMetaAppendix.ftl">
<#include "../typeSpan.ftl">
<#include "../component/downloadBlockInternal.ftl">
<#include "../component/downloadBlockAsset.ftl">
<#include "../component/downloadBlockExternal.ftl">

<#macro downloadSection section mainHeadingLevel=2 >

    <#assign hasLinks = section.items?? && section.items?size gt 0 />

    <div id="${slugify(section.heading)}" class="${(section.headingLevel == 'Main heading')?then('article-section navigationMarker', 'article-header__detail-lines navigationMarker-sub')}">

        <#if section.headingLevel == 'Main heading'>
            <#assign mainHeadingTag = "h" + mainHeadingLevel />
            <${mainHeadingTag} data-uipath="website.contentblock.download.title">${section.heading}</${mainHeadingTag}>
        <#else>
            <#assign subHeadingLevel = mainHeadingLevel?int + 1 />
            <#assign subHeadingTag = "h" + subHeadingLevel />
            <${subHeadingTag} data-uipath="website.contentblock.download.title">${section.heading}</${subHeadingTag}>
        </#if>

        <div data-uipath="website.contentblock.download.description"><@hst.html hippohtml=section.description contentRewriter=gaContentRewriter /></div>

        <#if hasLinks>
        <div class="article-section--list">
            <div class="grid-row">
                <div class="column column--reset">
                    <ul class="list list--reset cta-list cta-list--sections">
                        <#list section.items as block>
                            <#if block.linkType??>

                                <#if block.linkType == "internal">

                                    <@downloadBlockInternal document.class.name block.link block.link.title block.link.shortsummary  />

                                <#elseif block.linkType == "external">

                                    <@downloadBlockExternal document.class.name block.link "${block.title}" "${block.shortsummary}" />

                                <#elseif block.linkType == "asset">

                                    <@downloadBlockAsset document.class.name block.link "${block.title}" "" block.link.asset.mimeType block.link.asset.getLength()  />
<#--
					TODO what about this meetpdfa thing? 
-->
                                </#if>
                            </#if>
                        </#list>
                    </ul>
                    </div>
                </div>
            </div>
        </#if>


    </div>
</#macro>
