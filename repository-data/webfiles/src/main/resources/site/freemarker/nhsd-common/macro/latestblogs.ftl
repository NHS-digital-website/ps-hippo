<#ftl output_format="HTML">

<#include "../../include/imports.ftl">
<#include "component/showAll.ftl">

<#assign itemsMaxCount=3/>

<#macro latestblogs blogs fromDoctype='Blog' idsuffix='latest-blogs' title="Latest blogs">

  <#assign hasLatestBlogs = blogs?has_content && blogs?size &gt; 0 />
  <#if hasLatestBlogs>
  <div id="related-articles-${slugify(idsuffix)}" class="latestBlog article-section related-articles--div filter-parent" data-max-count="${itemsMaxCount}" data-state="short">
        <h2>${title}</h2>

          <#list blogs as latest>
              <div class="latestBlog__item filter-list__item">
                  <div class="latestBlog__icon">
                      <#assign image = '' />
                      <#assign alttext = '' />
                      <#if latest.leadimagesection?? && latest.leadimagesection?has_content && latest.leadimagesection.leadImage?has_content >
                          <#assign image = latest.leadimagesection.leadImage />
                          <#assign alttext = latest.leadimagesection.alttext />
                      <#elseif latest.leadImage?? && latest.leadImage?has_content >
                          <#assign image = latest.leadImage />
                          <#assign alttext = latest.leadImageAltText />
                      </#if>
                      <#if image?has_content>
                          <@hst.link hippobean=image.original fullyQualified=true var="leadImage" />
                          <img class="latestBlog__icon__img" src="${leadImage}" alt="${alttext}" />
                      <#else>
                          <img class="latestBlog__icon__nhsimg" src="<@hst.webfile path="/images/fibre_57101102_med.jpg"/>" alt="NHS Digital article" >
                      </#if>
                  </div>

                  <div class="latestBlog__content">
                      <@hst.link hippobean=latest var="link"/>
                      <div class="latestBlog__title"><a class="cta__title cta__button" href="${link}" onClick="logGoogleAnalyticsEvent('Link click','${fromDoctype}','${link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${latest.title}">${latest.title}</a></div>
                          <div class="latestBlog__author">

                              <#if latest.authors?? && latest.authors?has_content>
                                  By <#list latest.authors as author>${author.title}<#sep>, </#list>.
                              </#if>

                              <#assign pubtime = '' />
                              <#if latest.dateOfPublication?has_content>
                                <#assign pubtime = latest.dateOfPublication.time />
                              <#elseif latest.publisheddatetime?has_content>
                                <#assign pubtime = latest.publisheddatetime.time />
                              </#if>

                              <#if ! pubtime?is_string >
                                <@fmt.formatDate value=pubtime type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />
                              </#if>
                          </div>
                      <div class="latestBlog__body">${latest.shortsummary}</div>
                  </div>
              </div>
          </#list>
          <@showAll blogs?has_content?then(blogs?size, 0) itemsMaxCount "" />
      </div>
  </#if>
</#macro>
