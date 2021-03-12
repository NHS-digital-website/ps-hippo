<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "fileMetaAppendix.ftl">
<#include "typeSpan.ftl">
<#include "stickyGroupBlockHeader.ftl">

<#assign lettersOfTheAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]/>

<#assign matchesFound = 0/>

<#macro alphabeticalGroupOfBlocks blockGroups>
<#if blockGroups?has_content>
<#list lettersOfTheAlphabet as letter>
    <#if blockGroups[letter]??>
    <#assign matchesFound++ />

    <div class="article-section article-section--letter-group" id="${slugify(letter)}">
        <@stickyGroupBlockHeader letter></@stickyGroupBlockHeader>

        <div class="grid-row">
            <div class="column column--reset">
                <div class="list list--reset cta-list cta-list--sections">
                    <#list blockGroups[letter] as block>
                    <div class="cta">
                        <#if block.linkType??>
                            <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, block.link) />

                            <@typeSpan block.linkType />

                            <#if block.linkType == "external">
                                <h2 class="cta__title"><a href="${block.link}" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${block.title}</a></h2>
                            <#elseif block.linkType == "asset">
                                <h2 class="cta__title"><a href="<@hst.link hippobean=block.link />" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${block.title}</a><@fileMetaAppendix block.link.asset.getLength()></@fileMetaAppendix></h2>
                            </#if>
                        <#else>
                            <@typeSpan "internal" />

                            <#if block.type?? && block.type?has_content && block.type == "alternativeTask">
                                <h2 class="cta__title"><a href="<@hst.link hippobean=block.task />">${block.title}</a></h2>
                            <#else>
                                <h2 class="cta__title"><a href="<@hst.link hippobean=block />">${block.title}</a></h2>
                            </#if>
                        </#if>

                        <p class="cta__text">${block.shortsummary}</p>
                    </div>
                    </#list>
                </div>
            </div>
        </div>
    </div>
    </#if>
</#list>
</#if>
</#macro>
