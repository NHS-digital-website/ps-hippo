<#ftl output_format="HTML">

<#-- Note Page must implement uk.nhs.digital.pagination.Paginated -->
<#macro pagination page earlyAccessKey="">
    <#assign pagination = page.paginate() />
    <#if (pagination)?has_content>
        <nav class="digital-pagination" aria-label="Pagination">
            <ul class="digital-pagination-list">
                <#if (pagination.previous)?has_content>
                    <li class="digital-pagination-list-item-previous">
                        <a class="digital-pagination-link"
                           href="<@hst.link hippobean=pagination.previous.linkedBean>
                                    <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
                                 </@hst.link>">
                            <span class="digital-pagination-link-title"><img aria-hidden="true" alt="Left Arrow" src="<@hst.webfile path="/images/pagination/left-arrow.svg"/>"/> Previous</span>
                            <span class="digital-pagination-link-hidden"> : </span>
                            <span class="digital-pagination-link-page">${pagination.previous.title}</span>
                        </a>
                    </li>
                </#if>
                <#if (pagination.next)?has_content>
                    <li class="digital-pagination-list-item-next">
                        <a class="digital-pagination-link"
                           href="<@hst.link hippobean=pagination.next.linkedBean>
                                    <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
                                 </@hst.link>">
                            <span class="digital-pagination-link-title">Next <img aria-hidden="true" alt="Right Arrow" src="<@hst.webfile path="/images/pagination/right-arrow.svg"/>"/></span>
                            <span class="digital-pagination-link-hidden"> : </span>
                            <span class="digital-pagination-link-page">${pagination.next.title}</span>
                        </a>
                    </li>
                </#if>
            </ul>
        </nav>
    </#if>
</#macro>
