<#ftl output_format="HTML">
<#include "typeSpan.ftl">
<#include "fileMetaAppendix.ftl">

<#macro hubPageComponents components>
<#if components?has_content>
<#assign component_list = components?keys/>
<#assign component_children_list = components?values/>
<#list component_list as component>
<div class="article-section article-section--hub-component">
    <div class="grid-row">
        <div class="column column--two-thirds column--left">
            <div class="rich-text-content" id="${slugify(component.title)}">
                <@hst.html hippohtml=component.component contentRewriter=gaContentRewriter/>
            </div>

            <#assign seq_index = component_list?seq_index_of(component) />
            <#assign componentChildPages = component_children_list[seq_index]/>
            <#if componentChildPages?has_content>
                <ol class="component-list list list--reset cta-list">
                    <#list componentChildPages as childPage>
                    <li>
                        <article class="cta">
                            <#if childPage.linkType??>
                                <@typeSpan childPage.linkType />
                                
                                <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, childPage.link) />
                                
                                <#if childPage.linkType == "external">
                                    <h2 class="cta__title"><a href="${childPage.link}" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${childPage.title}</a></h2>
                                <#elseif childPage.linkType == "asset">
                                    <h2 class="cta__title">
                                        <a href="<@hst.link hippobean=childPage.link />" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${childPage.title}</a><@fileMetaAppendix childPage.link.asset.getLength()></@fileMetaAppendix>
                                    </h2>
                                </#if>
                            <#elseif hst.isBeanType(childPage, 'org.hippoecm.hst.content.beans.standard.HippoBean')>
                                <@typeSpan "internal" />

                                <h2 class="cta__title"><a href="<@hst.link hippobean=childPage />">${childPage.title}</a></h2>
                            </#if>

                            <#if childPage.shortsummary?? && childPage.shortsummary?has_content>
                                <p class="cta__text">${childPage.shortsummary}</p>
                            </#if>
                        </article>
                    </li>
                    </#list>
                </ol>
            </#if>
        </div>
    </div>
</div>
</#list>
</#if>
</#macro>
