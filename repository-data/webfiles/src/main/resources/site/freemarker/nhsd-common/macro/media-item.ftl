<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#--
Macro for Media Item Tile

Params:

image                   Image   An image object
alttext                 String  Image alt text
feedItemTitle           String  Item Title
feedItemShortSummary    String  Short summary
pubtime                 Date    Date item
linkDestination         String  Where to link the entire item
className=""            String  (Optional) Extra classnames to append to the wrapping element

-->
<#macro mediaItem
    image
    alttext
    feedItemTitle
    feedItemShortSummary
    linkDestination
    date
    dateTo=''
    className=""
>

    <a href="${linkDestination}"
       class="media-item ${className}">
        <#if (image)?has_content>
            <@hst.link hippobean=image.original fullyQualified=true var="leadImage" />
            <figure class="media-item__media" style="background-image: url('${leadImage}')">
                <img src="${leadImage}" alt="${alttext}">
            </figure>
        </#if>
        <div class="media-item__content">
            <#if (date)?has_content>
                <#--shema:datePublished-->
                <@fmt.formatDate value=date type="Date" pattern="d MMMM yyyy" var="publishedDateTimeString" timeZone="${getTimeZone()}" />
                <@fmt.formatDate value=date type="Date" pattern="yyyy-MM-dd HH:mm:ss" var="publishedDateTime" timeZone="${getTimeZone()}" />

                <time class="media-item__date"
                      datetime="${publishedDateTime}">${publishedDateTimeString}</time>
            </#if>
            <#if (date)?has_content && (dateTo)?has_content >
                <@fmt.formatDate value=dateTo type="Date" pattern="d MMMM yyyy" var="toPublishedDateTimeString" timeZone="${getTimeZone()}" />
                <@fmt.formatDate value=dateTo type="Date" pattern="yyyy-MM-dd HH:mm:ss" var="toPublishedDateTime" timeZone="${getTimeZone()}" />
                 – <time class="media-item__date media-item__date--to"
                      datetime="${toPublishedDateTime}">${toPublishedDateTimeString}</time>

            </#if>
            <h3 class="media-item__title">${feedItemTitle}</h3>
            <p class="media-item__body">${feedItemShortSummary}</p>
            <div class="nhsd-icon-right-arrow"
                 role="presentation"></div>
        </div>
    </a>
</#macro>
