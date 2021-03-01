<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#-- @ftlvariable name="wrappingDocument" type="uk.nhs.digital.website.beans.Calltoaction" -->
<#-- @ftlvariable id="editMode" type="java.lang.Boolean"-->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#assign hasWrappingDoc = wrappingDocument?has_content />
<#assign hasWrappingDocLink = wrappingDocument.external?has_content || wrappingDocument.internal?has_content />

<#assign wrapperId = hasWrappingDoc?then("footer-section-wrapper-${slugify(wrappingDocument.title)}", "footer-section-wrapper") />

<nav aria-labelledby="${wrapperId}">
    <#if hasWrappingDoc>
        <div id="${wrapperId}" class="nhsd-t-body-s nhsd-!t-font-weight-bold nhsd-!t-margin-bottom-1">${wrappingDocument.title}</div>
    </#if>
    <#if pageable?? && pageable.items?has_content>
        <ul class="nhsd-t-list nhsd-t-list--links">
            <#list pageable.items as item>
                <#assign hasLink = item.external?has_content || item.internal?has_content />
                <#assign hasLabel = item.label?has_content />
                <#assign label = hasLabel?then(item.label, item.title) />

                <li class="nhsd-t-body-s">
                    <#if hasLink>
                        <#assign cookieBot = item.external?starts_with("javascript:") />
                        <#if item.external?has_content && !cookieBot>
                            <#assign externalLinkAttr>target="_blank" rel="external"</#assign>
                        </#if>

                        <#if item.internal?has_content>
                            <a class="nhsd-a-link nhsd-a-link--col-dark-grey" href="<@hst.link hippobean=item.internal/>">
                        <#else>
                            <a class="nhsd-a-link nhsd-a-link--col-dark-grey" href="${item.external}" ${externalLinkAttr}>
                        </#if>
                    </#if>
                    ${label}
                    <#if item.external?has_content>
                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                    </#if>
                    <#if hasLink>
                        </a>
                    </#if>
                </li>
            </#list>
        </ul>
    </#if>
</nav>
