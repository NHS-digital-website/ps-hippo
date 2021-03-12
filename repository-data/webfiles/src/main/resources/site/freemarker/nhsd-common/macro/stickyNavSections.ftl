<#ftl output_format="HTML">

<#assign isStickySectionMainHeading="uk.nhs.digital.freemarker.indices.IsStickySectionMainHeading"?new() />

<#macro stickyNavSections links title="Page contents">
<div class="article-section-nav-wrapper">
    <div class="article-section-nav">
        <h2 class="article-section-nav__title">${title}</h2>
        <#assign numberedListCount=0 />
        <#if links??>
            <nav>
                <ol class="article-section-nav__list">
                    <#list links as link>
                        <#assign label = "Scroll to '${link.title}'" />
                        <#if link["aria-label"]??>
                            <#assign label = link["aria-label"] />
                        </#if>
                        <#if link.isNumberedList?? && link.isNumberedList>
                            <#assign numberedListCount++ />
                            <#assign numberedLinkTitle = numberedListCount + ". " + link.title>
                            <li id="${link.url}_list" class="section-numbered">
                                <a href="${link.url}" aria-label="${label}" title="${label}" id="${link.url}_link" class="nonNavActive">${numberedLinkTitle}</a>
                            </li>
                        <#else>
                            <li id="${link.url}_list">
                                <a href="${link.url}" aria-label="${label}" title="${label}" id="${link.url}_link" class="nonNavActive">${link.title}</a>
                            </li>
                        </#if>
                    </#list>
                </ol>
            </nav>
        </#if>
    </div>
</div>
</#macro>

<#-- Gather section nav links in a hash -->
<#function getStickySectionNavLinks options>

    <#assign bundles = ["rb.generic.headers"] />
    <#if options??>
        <#if options.keepBundles??>
            <#assign bundles += options.keepBundles />
        </#if>
    </#if>
    <#assign var1 = bundles?join(",") />
    <@hst.setBundle basename="${var1}" />

    <#assign links = [] />
    <#if options??>
        <#if options.includeTopLink?? && options.includeTopLink>
            <#assign links = [{ "url": "#top", "title": "Top of page" }] />
        </#if>

        <#if options.includeSummary?? && options.includeSummary>
            <@fmt.message key="headers.summary" var="summaryHeader" />
            <#assign links += [{ "url": "#summary", "title": summaryHeader }] />
        </#if>

        <#if options.sections??>
            <#assign links += options.sections />
        </#if>

        <#if options.document??>
            <#if options.document.sections?has_content>
                <#list options.document.sections as section>
                    <#if isStickySectionMainHeading(section)>
                        <#if section.isNumberedList??>
                          <#assign links += [{ "url": "#" + slugify(section.heading), "title": section.heading, "isNumberedList": section.isNumberedList}] />
                        <#else>
                          <#assign links += [{ "url": "#" + slugify(section.heading), "title": section.heading, "isNumberedList": false}] />
                        </#if>
                    </#if>
                </#list>
            </#if>
            <#if options.document.contactdetails?? && options.document.contactdetails.content?has_content>
                <@fmt.message key="headers.contact-details" var="contactDetailsHeader" />
                <#assign links += [{ "url": "#contact-details", "title": contactDetailsHeader }] />
            </#if>
        </#if>
        <#if document?? && document != "simulating_doc" && document.relatedNews?? && (!document.latestNews?? || !document.latestNews?has_content) && document.relatedNews?has_content >
              <#assign links += [{ "url": "#related-articles-related-news-${idsuffix}", "title": 'Related news' }] />
        </#if>
        <#if options.childPages?? && options.childPages?has_content>
            <@fmt.message key="headers.further-information" var="furtherInformationHeader" />
            <#assign links += [{ "url": "#further-information", "title": furtherInformationHeader }] />
        </#if>

        <#if options.appendSections?has_content>
            <#list options.appendSections as section>
                <#assign links += [{ "url": "#" + slugify(section.title), "title": section.title, "isNumberedList": false}] />
            </#list>
        </#if>
    </#if>

    <#return links />
</#function>
