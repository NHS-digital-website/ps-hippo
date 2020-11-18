<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<@hst.setBundle basename="homepage.website.labels"/>

<#if pageable?? && pageable.items?has_content>
<div>
    <h3 class="list-title"><@fmt.message key="about-us.latestNewsTitle"/></h3>

    <ol class="list list--reset cta-list">
        <#list pageable.items as item>
        <li class="has-edit-button">
            <article class="cta">
                <h2 class="cta__title">
                    <a href="<@hst.link hippobean=item/>" title="${item.title}">${item.title}</a>
                </h2>

                <#if item.publisheddatetime?? && item.publisheddatetime.time??>
                    <p class="cta__meta"><span class="strong"><@fmt.message key="about-us.newsDateLabel"/>: </span>
                        <@fmt.formatDate value=item.publisheddatetime.time type="Date" pattern="yyyy-MM-dd HH:mm:ss" var="publishedDateTime" timeZone="${getTimeZone()}" />
                        <@fmt.formatDate value=item.publisheddatetime.time type="Date" pattern="d MMMM yyyy" var="publishedDateTimeForHumans" timeZone="${getTimeZone()}"/>
                        <time datetime="${publishedDateTime}">${publishedDateTimeForHumans}</time>
                    </p>
                </#if>
            </article>
        </li>

        </#list>
    </ol>

    <a href="/news" class="button"><@fmt.message key="about-us.latestNewsButtonLabel"/></a>

</div>

</#if>
