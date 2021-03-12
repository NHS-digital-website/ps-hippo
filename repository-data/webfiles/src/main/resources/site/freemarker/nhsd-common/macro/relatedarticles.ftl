<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

<#function isAnyNotPersonDoctype articles>
  <#list articles as article>
    <#if article.class.name != "uk.nhs.digital.website.beans.Person">
      <#return true /> 
    </#if>
  </#list>
  <#return false />
</#function>

<#macro relatedarticles articles articleType showDates=true idsuffix='id' title='Related documents' showSummary=false>
  <#if articles?has_content && isAnyNotPersonDoctype(articles) >
    <div id="related-articles-${slugify(idsuffix)}" class="article-section related-articles--div">
        <h2>${title}</h2> 
        <div class="list">
            <#list articles as article>
            <#if article.class.name != "uk.nhs.digital.website.beans.Person">
              <#-- do NOT display Person doctypes as related documents-->
              <div>
                  <@hst.link hippobean=article var="link"/>
                  <a href="${link}" onClick="logGoogleAnalyticsEvent('Link click','${articleType}','${link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${article.title}">${article.title}</a>
                  <#if showDates>
                    <#assign dateandtime = "" />
                    <#if article.publisheddatetime?? && article.publisheddatetime?has_content>
                      <#-- ex. for news doctype-->
                      <#assign dateandtime = article.publisheddatetime.time />
                    <#elseif article.events?? && article.events?has_content>
                      <#-- .ex. for events doctype - get startdate of latest event-->
                      <#list article.events as event>
                        <#assign dateandtime = event.startdatetime.time />
                      </#list>
                    </#if>

                    <#if dateandtime?has_content>
                      <div class="article__date-list-item">
                          <@fmt.formatDate value=dateandtime type="Date" pattern="d MMMM yyyy" var="publishedDateTimeString" timeZone="${getTimeZone()}" />
                          <@fmt.formatDate value=dateandtime type="Date" pattern="yyyy-MM-dd HH:mm:ss" var="publishedDateTime" timeZone="${getTimeZone()}" />
                          <time datetime="${publishedDateTime}">${publishedDateTimeString}</time>
                      </div>
                    </#if>
                  </#if>
                  <#if showSummary && article.shortsummary?? && article.shortsummary?has_content>
                    <div>${article.shortsummary}</div>
                  </#if>
              </div>
            </#if>
            </#list>
        </div>
    </div>
  </#if>
</#macro>
