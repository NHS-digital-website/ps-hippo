<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">

<#macro slimPicture config>
    <#local document = config.document />
    <#if config.bannerImageSmall2x??>
        <#local bannerImageSmall2x = config.bannerImageSmall2x />
    </#if>
    <#if config.bannerImageSmall??>
        <#local bannerImageSmall = config.bannerImageSmall />
    </#if>
    <#if config.bannerImage2x??>
        <#local bannerImage2x = config.bannerImage2x />
    </#if>
    <#if config.bannerImage??>
        <#local bannerImage = config.bannerImage />
    </#if>
    <#local bannerImageAltText = config.bannerImageAltText />

    <@hst.headContribution>
        <style type="text/css">
            .banner-image {
                background-image: url(${bannerImageSmall});
            }

            @media screen and (min-device-pixel-ratio: 2) {
                .banner-image {
                    background-image: url(${bannerImageSmall2x});
                }
            }

            @media screen and (min-width: 750px) {
                .banner-image {
                    background-image: url(${bannerImage});
                }
            }

            @media screen and (min-device-pixel-ratio: 2) and (min-width: 750px) {
                .banner-image {
                    background-image: url(${bannerImage2x});
                }
            }
        </style>
    </@hst.headContribution>

    <div class="banner-image" aria-label="Document Header" style="background-image: url(${bannerImage});">
        <#if document.bannerImageAltText??>
            <#-- Add some descriptive text to the otherwise inaccessible background image -->
            <span role="img" aria-label="${bannerImageAltText}"> </span>
        </#if>
        <div class="grid-wrapper">
            <div class="grid-row">
                <div class="column column--reset banner-image-title">
                    <div class="banner-image-title-background">
                        <h1 data-uipath="document.title">${document.title}</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>
