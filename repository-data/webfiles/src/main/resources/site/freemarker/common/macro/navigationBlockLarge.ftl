<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "./digiBlock.ftl">

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<#macro navigationBlockLarge item id colourVariant isDarkMolecule isYellowLink isDarkButton position>
    <#assign hasTitle = item.title?has_content />
    <#assign hasContent = item.content?has_content />
    <#assign hasImage = item.image?has_content />
    <#assign hasLink = item.external?has_content || item.internal?has_content />
    <#assign hasLabel = item.label?has_content />
    <#assign colVarWithYellowCheck = (colourVariant == yellow)?then("light-yellow", colourVariant) />

    <div class="nhsd-m-nav-block ${isDarkMolecule}" id="${id}">
        <#if hasLink>
            <#if item.internal?has_content>
                <a href="<@hst.link hippobean=item.internal/>" class="nhsd-a-box-link ${isYellowLink}" aria-label="${label}">
            <#else>
                <a href="${item.external}" class="nhsd-a-box-link ${isYellowLink}" aria-label="${label}" target="_blank" rel="external">
            </#if>
        </#if>
        <div class="nhsd-a-box nhsd-a-box--bg-${colVarWithYellowCheck}">
            <div class="nhsd-m-nav-block__content-box">
                <div class="nhsd-a-icon nhsd-a-icon--size-xxl">
                    <#if hasImage>
                        <figure class="nhsd-a-image nhsd-a-image--square" aria-hidden="true">
                            <picture class="nhsd-a-image__picture">
                                <@hst.link hippobean=item.image var="image"/>
                                <#assign imgDescription = item.image.description />
                                <#assign altText = imgDescription?has_content?then(imgDescription, "image of ${id}") />

                                <#if image?ends_with("svg")>
                                    <#assign lightTxt = "FFFFFF" />
                                    <#assign darkTxt = "231F20" />
                                    <#assign colour = isDarkMolecule?has_content?then(lightTxt, darkTxt)/>

                                    <#assign imageUrl = '${image?replace("/binaries", "/svg-magic/binaries")}' />
                                    <#assign imageUrl += "?colour=${colour}" />
                                    <img src="${imageUrl}" alt="${altText}">
                                <#else>
                                    <img src="${image}" alt="${altText}">
                                </#if>
                            </picture>
                        </figure>
                    <#else>
                        <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16">
                            <path d="M8,16l-6.9-4V4L8,0l6.9,4v8L8,16z M2,11.5L8,15l6-3.5v-7L8,1L2,4.5V11.5z"/>
                            <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="42%" height="42%" x="29%" y="29%">
                                <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                            </svg>
                        </svg>
                    </#if>
                </div>
                <#if hasTitle>
                    <h1 class="nhsd-t-heading-xl">${item.title}</h1>
                </#if>
                <#if hasContent>
                    <p class="nhsd-t-body">${item.content}</p>
                </#if>

                <#if hasLink && hasLabel>
                    <span class="nhsd-a-button ${isDarkButton}">
                        <span class="nhsd-a-button__label">${item.label}</span>
                        <#if item.external?has_content>
                            <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                        </#if>
                    </span>
                </#if>
            </div>
            <@digiBlock colourVariant position/>
        </div>
        <#if hasLink>
            </a>
        </#if>
    </div>
</#macro>
