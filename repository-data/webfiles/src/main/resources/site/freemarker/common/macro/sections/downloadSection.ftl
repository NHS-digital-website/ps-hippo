<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Download" -->

<#include "../fileIconByMimeType.ftl">
<#include "../fileIconByFileType.ftl">
<#include "../fileMetaAppendix.ftl">
<#include "../typeSpan.ftl">
<#include "../component/downloadBlock.ftl">

<#macro downloadSection section mainHeadingLevel=2 >

    <#assign hasLinks = section.items?? && section.items?size gt 0 />

<div id="${slugify(section.heading)}" class="${(section.headingLevel == 'Main heading')?then('article-section', 'article-header__detail-lines')}">
        <#if section.heading?? && section.headingLevel??>
        <div id="${slugify(section.heading)}" class="${(section.headingLevel == 'Main heading')?then('article-section navigationMarker', 'article-header__detail-lines navigationMarker-sub')}">
        <#else>
        <div class="article-header__detail-lines">
        </#if>

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
                        <li>
                            <#if block.linkType??>
                                <@typeSpan block.linkType />

                                <#if block.linkType == "internal">

                                    <@downloadBlock block.link />

                                <#elseif block.linkType == "external">
                                    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, block.title) />

                                    <a href="${block.link}"
                                       class="block-link"
                                       onClick="${onClickMethodCall}"
                                       onKeyUp="return vjsu.onKeyUp(event)">
                                        <div class="block-link__header">
                                            <@fileIconByFileType block.link />
                                        </div>
                                        <div class="block-link__body">
                                            <span class="block-link__title">${block.title}</span>
                                            <p class="cta__text">${block.shortsummary}</p>
                                        </div>
                                    </a>

                                <#elseif block.linkType == "asset">
                                    <@hst.link hippobean=block.link var="link" />
                                    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, link) />

                                    <a href="${link}"
                                       class="block-link"
                                       onClick="${onClickMethodCall}"
                                       onKeyUp="return vjsu.onKeyUp(event)">
                                    <div class="block-link__header">
                                        <@fileIconByMimeType block.link.asset.mimeType></@fileIconByMimeType>
                                    </div>
                                    <div class="block-link__body">
                                        <span class="block-link__title">${block.title}</span>
                                        <#assign meetpdfa = false />
                                        <#if block.link.meetpdfa?? && block.link.meetpdfa >
                                          <#assign meetpdfa = true />
                                        </#if>
                                        <@fileMetaAppendix block.link.asset.getLength() block.link.asset.mimeType meetpdfa link></@fileMetaAppendix>
                                    </div>
                                    </a>
                                </#if>
                            </#if>
                        </li>
                        </#list>
                    </ul>
                    </div>
                </div>
            </div>
        </#if>
    </div>
</#macro>
