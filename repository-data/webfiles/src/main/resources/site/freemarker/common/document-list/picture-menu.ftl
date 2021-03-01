<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "../macro/gridColumnGenerator.ftl">

<#-- @ftlvariable name="wrappingDocument" type="uk.nhs.digital.website.beans.Calltoaction" -->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#assign hasWrappingDoc = wrappingDocument?has_content />
<#assign hasWrappingDocLink = wrappingDocument.external?has_content || wrappingDocument.internal?has_content />

<div class="nhsd-o-image-with-link-list nhsd-!t-margin-bottom-9">
    <div class="nhsd-t-grid">
        <#if hasWrappingDoc>
            <div class="nhsd-t-row">
                <div class="nhsd-t-col">
                    <h2 class="nhsd-t-heading-xl nhsd-t-text-align-center nhsd-!t-margin-bottom-7">${wrappingDocument.title}</h2>
                </div>
            </div>
        </#if>
        <#if pageable?? && pageable.items?has_content>
            <div class="nhsd-t-row nhsd-o-image-with-link-list__items nhsd-t-row--centred">
                <#list pageable.items as item>
                    <#assign hasImage = item.image?has_content />
                    <#assign hasLink = item.external?has_content || item.internal?has_content />
                    <#assign hasLabel = item.label?has_content />
                    <#assign hasTitle = item.title?has_content />

                    <div class="nhsd-t-col-xs-12 ${getGridCol(pageable.items?size, "large")}">
                        <div class="nhsd-m-image-with-link">
                            <figure class="nhsd-a-image nhsd-a-image--round-corners nhsd-!t-margin-bottom-2" aria-hidden="true">
                                <picture class="nhsd-a-image__picture">
                                    <#assign altTextDefault = "image of picture menu ${item?index + 1}" />
                                    <#if hasImage>
                                        <#assign altText = item.image.description?has_content?then(item.image.description, altTextDefault) />
                                        <@hst.link hippobean=item.image var="image"/>
                                        <img src="${image}" alt="${altText}">
                                    <#else>
                                        <img src="https://digital.nhs.uk/binaries/content/gallery/website/about-nhs-digital/fibre_57101102_med.jpg" alt="${altTextDefault}">
                                    </#if>
                                </picture>
                            </figure>

                            <#if hasLink && hasLabel>
                                <div class="nhsd-t-heading-s">
                                    <#assign linkLabel = item.label />
                                    <#if item.internal?has_content>
                                        <a class="nhsd-a-link" href="<@hst.link hippobean=item.internal/>">
                                    <#else>
                                        <a class="nhsd-a-link" href="${item.external}" target="_blank" rel="external">
                                    </#if>
                                    ${linkLabel}
                                    <#if item.external?has_content>
                                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                                    </#if>

                                    <#if hasLink && hasLabel>
                                        </a>
                                    </#if>
                                </div>
                            </#if>
                        </div>
                    </div>
                </#list>
            </div>
        </#if>

        <#if hasWrappingDoc && hasWrappingDocLink>
            <div class="nhsd-t-row">
                <div class="nhsd-t-col">
                    <nav class="nhsd-m-button-nav">
                        <#if wrappingDocument.internal?has_content>
                            <a class="nhsd-a-button" href="<@hst.link hippobean=wrappingDocument.internal/>">
                        <#elseif wrappingDocument.external?has_content>
                            <a class="nhsd-a-button" href="${wrappingDocument.external}" target="_blank" rel="external">
                        </#if>

                        <span class="nhsd-a-button__label">${wrappingDocument.label}</span>

                        <#if wrappingDocument.external?has_content>
                            <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                        </#if>
                        </a>
                    </nav>
                </div>
            </div>
        </#if>
    </div>
</div>
