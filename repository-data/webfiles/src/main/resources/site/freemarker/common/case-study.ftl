<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<#-- @ftlvariable name="document" type="uk.nhs.digital.website.beans.Calltoaction" -->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#assign hasDocument = document?has_content />
<#assign hasAlignment = textAlignment?has_content />
<#assign isRightAlignment = (hasAlignment && textAlignment == "right")?then("nhsd-o-case-study--mirrored", "") />

<#if hasDocument>
    <#assign hasTitle = document.title?has_content />
    <#assign hasContent = document.content?has_content />
    <#assign hasImage = document.image?has_content />
    <#assign hasLink = (document.external?has_content || document.internal?has_content) && document.label?has_content />

    <article class="nhsd-o-case-study nhsd-o-case-study--no-label nhsd-!t-margin-bottom-9 ${isRightAlignment}">
        <div class="nhsd-t-grid">
            <div class="nhsd-t-row">
                <div class="nhsd-t-col-xs-12">
                    <div class="nhsd-o-case-study__wrapper nhsd-t-row--centred">
                        <div class="nhsd-o-case-study__content-box">
                            <div class="nhsd-o-case-study__contents">
                                <#if hasTitle>
                                    <h1 class="nhsd-t-heading-xl nhsd-!t-margin-bottom-3">${document.title}</h1>
                                </#if>
                                <figure class="nhsd-a-image">
                                    <picture class="nhsd-a-image__picture">
                                        <#if hasImage>
                                            <@hst.link hippobean=document.image var="image" />
                                            <img src="${image}" alt="${document.title}">
                                        <#else>
                                            <img src="https://digital.nhs.uk/binaries/content/gallery/website/about-nhs-digital/fibre_57101102_med.jpg" alt="${document.title}">
                                        </#if>
                                    </picture>
                                </figure>

                                <#if hasContent>
                                    <p class="nhsd-t-body nhsd-!t-margin-bottom-4">${document.content}</p>
                                </#if>

                                <#if hasLink>
                                    <#assign linkLabel = document.label />

                                    <#if document.internal?has_content>
                                        <@hst.link hippobean=document.internal var="link"/>
                                    <#elseif document.external?has_content>
                                        <#assign link = document.external/>
                                    </#if>

                                    <#if document.external?has_content>
                                        <a class="nhsd-a-button nhsd-!t-margin-bottom-0" href="${link}" target="_blank" rel="external">
                                    <#else>
                                        <a class="nhsd-a-button nhsd-!t-margin-bottom-0" href="${link}">
                                    </#if>

                                    <span class="nhsd-a-button__label">${linkLabel}</span>

                                    <#if document.external?has_content>
                                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                                    </#if>
                                    </a>
                                </#if>
                            </div>
                        </div>
                        <div class="nhsd-o-case-study__picture-skeleton"></div>
                    </div>
                </div>
            </div>
        </div>
    </article>
</#if>
