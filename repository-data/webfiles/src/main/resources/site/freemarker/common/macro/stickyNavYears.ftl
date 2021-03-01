<#ftl output_format="HTML">

<#macro stickyNavYears links affix="" title="Filter by year">
<div class="article-section-nav-wrapper">
    <div class="article-section-nav">
        <h2 class="article-section-nav__title">${title}</h2>
        <#if links??>
            <nav>
                <ol class="article-section-nav__list article-section-nav__list--tag-links">
                <#assign selectedIndex = -1 />
                <#list links as link>
                    <li>
                        <#assign selectedIndex = (selectedYear == link.key)?then(link?index, selectedIndex) />

                        <#assign hasCount = (link.count?? && link.count?has_content)?then("(" + link.count + ")", "") />
                        <#assign selected = (selectedYear == link.key)?then("selected", "") />
                        <#assign hidden = (link?index gte 10 && selectedIndex lt 10 && !expandYearsTags)?then("tag-link--hidden", "") />
                        <a href="?year=${link.key + affix}" title="Show '${link.title}' only" class="tag-link ${selected} ${hidden}" data-type="year" data-slugified-value="${slugify(link.title)}">${link.title} ${hasCount}</a>
                    </li>
                </#list>
                </ol>
                <#if !expandYearsTags && selectedIndex lt 10 && links?size gt 10>
                    <a href="?expandYearsTags=true${affix}" class="expand-tags-link">Show more years</a>
                </#if>
            </nav>
        </#if>
    </div>
</div>
</#macro>
