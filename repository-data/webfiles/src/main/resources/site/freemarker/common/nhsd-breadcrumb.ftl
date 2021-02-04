<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/iconGenerator.ftl">

<#if breadcrumb?? && breadcrumb.items?size gte 1>
<div class="nhsd-t-grid nhsd-!t-padding-top-3 nhsd-!t-padding-bottom-3">
    <div class="nhsd-t-row">
        <div class="nhsd-t-col">
            <nav class="nhsd-m-breadcrumbs" aria-label="Breadcrumb">
                <ol class="nhsd-m-breadcrumbs__list">
                    <li class="nhsd-m-breadcrumbs__item">
                        <a class="nhsd-a-link nhsd-a-link--col-dark-grey" href="<@hst.link siteMapItemRefId='root'/>">NHS Digital</a>
                        <@buildInlineSvg "chevron-right" "xxs", "nhsd-a-icon--col-dark-grey" />
                    </li>
                    <#list breadcrumb.items as item>
                        <li class="nhsd-m-breadcrumbs__item">
                            <#if !item?is_last>
                                <@hst.link var="link" link=item.link/>
                                <a class="nhsd-a-link nhsd-a-link nhsd-a-link--col-dark-grey" href="${link}" data-text="${item.title}">${item.title}</a>
                                <@buildInlineSvg "chevron-right" "xxs", "nhsd-a-icon--col-dark-grey" />
                            <#else>
                                <span class="nhsd-t-body-s" aria-current="page" data-text="${item.title}">${item.title}</span>
                            </#if>
                        </li>
                    </#list>
                </ol>
            </nav>
        </div>
    </div>
</div>
</#if>
