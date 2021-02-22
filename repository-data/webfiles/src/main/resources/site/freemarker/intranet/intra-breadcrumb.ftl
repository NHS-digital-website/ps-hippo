<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<#if breadcrumb?? && breadcrumb.items?size gte 1>
<div class="nhsd-t-grid nhsd-!t-padding-0">
    <div class="nhsd-t-row">
        <div class="nhsd-t-col nhsd-!t-padding-0">
            <nav class="nhsd-m-breadcrumbs" aria-label="Breadcrumb">
                <ol class="nhsd-m-breadcrumbs__list nhsd-!t-padding-top-1 nhsd-!t-padding-bottom-1">
                    <li class="nhsd-m-breadcrumbs__item">
                        <a class="nhsd-a-link nhsd-a-link--col-dark-grey" data-text="NHS Digital" href="<@hst.link siteMapItemRefId='root'/>">NHS Digital</a>
                    </li>
                    <#list breadcrumb.items as item>
                        <li class="nhsd-m-breadcrumbs__item">
                            <span class="nhsd-a-icon nhsd-a-icon--size-xxs nhsd-a-icon--col-dark-grey">
                                <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                    <path d="M12,8l-6.5,7L4,13.5L9.2,8L4,2.5L5.5,1L12,8z"/>
                                </svg>
                            </span>
                            <#if !item?is_last>
                            <@hst.link var="link" link=item.link/>
                            <a class="nhsd-a-link nhsd-a-link--col-dark-grey" href="${link}" data-text="${item.title}">${item.title}</a>
                            <#else>
                            <span class="nhsd-t-body-s" data-text="${item.title}" aria-current="page">${item.title}</span>
                            </#if>
                        </li>
                    </#list>
                </ol>
            </nav>
        </div>
    </div>
</div>
<hr class="nhsd-a-horizontal-rule nhsd-!t-margin-top-1 nhsd-!t-margin-bottom-0" />
</#if>
