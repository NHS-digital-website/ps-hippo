<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#-- @ftlvariable name="socialMedia" type="uk.nhs.digital.website.beans.SocialMedia" -->

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.sr-only-link" var="srOnlyLinkText" />

<div id="footer-section-wrapper-social-media">
    <#if title?has_content>
        <div class="nhsd-t-body-s nhsd-!t-font-weight-bold nhsd-!t-margin-bottom-1">${title}</div>
    </#if>
    <#if socialmedia??>
        <ul class="nhsd-t-list nhsd-t-list--links">
            <#list socialmedia as socialmediaItem>
                <li class="nhsd-t-body-s">
                    <@hst.link hippobean=socialmediaItem.linkIcon var="linkIcon" />
                    <#assign iconDesc = socialmediaItem.linkIcon.description />
                    <#assign altText = iconDesc?has_content?then(iconDesc, "Icon of ${socialmediaItem.linkName}") />

                    <#if linkIcon?has_content>
                        <span class="nhsd-a-icon nhsd-a-icon--size-l nhsd-a-icon--col-dark-grey">
                            <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16">
                              <path d="M8,16l-6.9-4V4L8,0l6.9,4v8L8,16z M2,11.5L8,15l6-3.5v-7L8,1L2,4.5V11.5z"/>
                            </svg>
                            <#if linkIcon?ends_with("svg")>
                                <#assign colour = "3f525f" />
                                <#assign imageUrl = '${linkIcon?replace("/binaries", "/svg-magic/binaries")}' />
                                <#assign imageUrl += "?colour=${colour}" />
                                <img src="${imageUrl}" alt="${altText}" aria-hidden="true">
                            <#else>
                                <img src="${linkIcon}" alt="${altText}" aria-hidden="true">
                            </#if>
                        </span>
                    </#if>
                    <a class="nhsd-a-link nhsd-a-link--col-dark-grey" href="${socialmediaItem.nhsDigitalUrl}" target="_blank" rel="external">
                        ${socialmediaItem.linkName}
                        <span class="nhsd-t-sr-only">${srOnlyLinkText}</span>
                    </a>
                </li>
            </#list>
        </ul>
    </#if>
</div>
