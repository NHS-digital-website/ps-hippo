<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/iconGenerator.ftl">

<#-- @ftlvariable name="menu" type="org.hippoecm.hst.core.sitemenu.HstSiteMenu" -->
<#-- @ftlvariable name="editMode" type="java.lang.Boolean"-->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#if menu??>
    <nav class="nhsd-m-menu-bar">
        <#if menu.siteMenuItems??>
            <#list menu.siteMenuItems as item>
                <#assign activeClass = (item.selected || item.expanded)?then("js-active", "") />

                <#if item.hstLink??>
                    <#assign href><@hst.link link=item.hstLink/></#assign>
                    <#assign externalLinkAttr></#assign>
                <#elseif item.externalLink??>
                    <#assign href>${item.externalLink?replace("\"", "")}</#assign>
                    <#assign externalLinkAttr>target="_blank" rel="external"</#assign>
                <#else>
                    <#assign href>#</#assign>
                    <#assign externalLinkAttr></#assign>
                </#if>

                <a class="nhsd-a-menu-item ${activeClass}" href="${href}" ${externalLinkAttr}>
                    <span class="nhsd-a-menu-item__label">${item.name}</span>
                    <#if item.externalLink??>
                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                    </#if>
                    <span class="nhsd-a-icon nhsd-a-icon--size-s"><@buildInlineSvg "right" "s"/></span>
                </a>
            </#list>
        </#if>
        <@hst.cmseditmenu menu=menu/>
    </nav>
</#if>

