<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<#-- @ftlvariable name="document" type="uk.nhs.digital.website.beans.Calltoaction" -->
<#-- @ftlvariable name="document" type="uk.nhs.digital.website.beans.Banner" -->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#assign hasDocument = document?has_content />

<#-- Size -->
<#assign isTall = size == "tall" />
<#assign accented = isTall?then("nhsd-o-hero-feature--accented","")/>
<#assign headingSize = isTall?then("nhsd-t-heading-xxl","nhsd-t-heading-l")/>
<#assign colSize = isTall?then("nhsd-t-col-xs-12","nhsd-t-col-xs-11")/>
<#assign marginSize = isTall?then("nhsd-!t-margin-bottom-9", "nhsd-!t-margin-bottom-0") />
<#assign imageSize = isTall?then("nhsd-a-image--square","")/>

<#-- Alignment -->
<#assign hasTextAlignment = textAlignment?has_content />
<#assign mirrored = (hasTextAlignment && textAlignment == "right")?then("nhsd-o-hero-feature--mirrored","")/>

<#-- Colourbar -->
<#assign hasColourBar = isTall?then(displayColourBar, false) />

<#if hasDocument>
    <#assign isCtaDoc = document.class.simpleName == "Calltoaction"/>
    <#assign isBannerDoc = document.class.simpleName == "Banner"/>
    <#assign isVideoDoc = document.class.simpleName == "Video"/>

    <#assign hasTitle = document.title?has_content />
    <#assign hasContent = document.content?has_content || document.introduction?has_content />
    <#assign hasLink = document.external?has_content || document.internal?has_content || document.link?has_content />
    <#assign hasImage = document.image?has_content />
    <#assign hasImageDesc = (hasImage && document.image.description?has_content) />
    <#assign altText = hasImageDesc?then(document.image.description, isTall?then("image of the main hero image", "image of the secondary hero image")) />

    <div class="nhsd-o-hero-feature ${accented} ${mirrored}">
        <div class="nhsd-t-grid nhsd-t-grid--full-width nhsd-!t-no-gutters">
            <div class="nhsd-t-row nhsd-t-row--centred">
                <div class="nhsd-t-col-s-6 nhsd-!t-no-gutters ${colSize}">
                    <div class="nhsd-o-hero__content-box">
                        <div class="nhsd-o-hero__content">
                            <#if hasTitle>
                                <span class="${headingSize}">${document.title}</span>
                            </#if>

                            <#if hasContent>
                                <p class="nhsd-t-body nhsd-!t-margin-bottom-6">
                                    <#if isBannerDoc>
                                        <@hst.html hippohtml=document.content var="summaryText" />
                                        ${summaryText?replace('<[^>]+>','','r')}
                                    <#elseif isCtaDoc>
                                        ${document.content}
                                    <#elseif isVideoDoc>
                                        <@hst.html hippohtml=document.introduction var="summaryText" />
                                        ${summaryText?replace('<[^>]+>','','r')}
                                    </#if>
                                </p>
                            </#if>

                            <#if hasLink>
                                <#if document.internal?has_content>
                                    <@hst.link hippobean=document.internal var="link"/>
                                    <#assign linkLabel = document.label />
                                <#elseif document.external?has_content>
                                    <#assign link = document.external/>
                                    <#assign linkLabel = document.label />
                                <#elseif document.link?has_content>
                                    <@hst.link hippobean=document.link var="link"/>
                                    <#assign linkLabel = document.link.title />
                                </#if>

                                <#if linkLabel?has_content>
                                    <#if document.external?has_content>
                                        <a class="nhsd-a-button ${marginSize}" href="${link}" target="_blank" rel="external">
                                    <#else>
                                        <a class="nhsd-a-button ${marginSize}" href="${link}">
                                    </#if>

                                    <span class="nhsd-a-button__label">${linkLabel}</span>

                                    <#if document.external?has_content>
                                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                                    </#if>
                                    </a>
                                </#if>
                            </#if>
                        </div>

                        <#if hasColourBar>
                            <span class="nhsd-a-colour-bar"></span>
                        </#if>
                    </div>
                </div>

                <div class="nhsd-t-col-s-6 nhsd-!t-no-gutters ${colSize}">
                    <figure class="nhsd-a-image ${imageSize}" aria-hidden="true">
                        <#if isVideoDoc && document.videoUri???has_content>
                             <div style="padding-bottom: 56.25%; position: relative">
                                <iframe style="width: 100%; height: 100%; position: absolute" type="text/html" src="${document.videoUri}" frameborder="0" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe>
                                <link itemprop="embedUrl" href="${document.videoUri}" />
                             </div>
                        <#elseif document.image?has_content>
                            <picture class="nhsd-a-image__picture">
                                <@hst.link hippobean=document.image var="image" />
                                <img src="${image}" alt="${altText}">
                            </picture>
                        <#else>
                            <picture class="nhsd-a-image__picture">
                                <img src="https://digital.nhs.uk/binaries/content/gallery/website/about-nhs-digital/fibre_57101102_med.jpg" alt="${altText}">
                            </picture>
                        </#if>
                    </figure>
                </div>
            </div>
        </div>
    </div>
</#if>


