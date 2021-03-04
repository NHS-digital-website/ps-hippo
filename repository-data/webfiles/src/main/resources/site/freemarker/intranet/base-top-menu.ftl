<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<#-- @ftlvariable name="menu" type="org.hippoecm.hst.core.sitemenu.HstSiteMenu" -->
<#-- @ftlvariable name="editMode" type="java.lang.Boolean"-->
<#if menu??>
<nav class="nhsd-m-menu-bar">
    <#if menu.siteMenuItems??>
    <#list menu.siteMenuItems as item>
        <#if !item.hstLink?? && !item.externalLink??>
        <#if item.selected || item.expanded>
        <a class="nhsd-a-menu-item js-active">
            <span class="nhsd-a-menu-item__label">${item.name}</span>
            <span class="nhsd-a-icon nhsd-a-icon--size-s">
                <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                    <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                </svg>
            </span>
        </a>
        <#else>
        <a class="nhsd-a-menu-item">
            <span class="nhsd-a-menu-item__label">${item.name}</span>
            <span class="nhsd-a-icon nhsd-a-icon--size-s">
                <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                    <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                </svg>
            </span>
        </a>
        </#if>
        <#else>
        <#if item.hstLink??>
        <#assign href><@hst.link link=item.hstLink/></#assign>
        <#elseif item.externalLink??>
        <#assign href>${item.externalLink?replace("\"", "")}</#assign>
        </#if>
        <#if  item.selected || item.expanded>
        <a class="nhsd-a-menu-item js-active" href="${href}">
            <span class="nhsd-a-menu-item__label">${item.name}</span>
            <span class="nhsd-a-icon nhsd-a-icon--size-s">
                <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                    <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                </svg>
            </span>
        </a>
        <#else>
        <a class="nhsd-a-menu-item" href="${href}">
            <span class="nhsd-a-menu-item__label">${item.name}</span>
            <span class="nhsd-a-icon nhsd-a-icon--size-s">
                <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                    <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                </svg>
            </span>
        </a>
        </#if>
        </#if>
    </#list>
    </#if>
    <@hst.cmseditmenu menu=menu/>
</nav>
</#if>
