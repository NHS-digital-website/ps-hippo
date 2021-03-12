<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

  <#macro award awards idsuffix firstname>
    <#if awards?has_content>
    <div id="award-${slugify(idsuffix)}" class="award--div article-section">
      <h2>Awards</h2> 

        <p>
          <#if awards?has_content >
            ${firstname} has won awards for:
            <ul>
              <#list awards as personaward>
                <div>
                  <#assign awardnameDisplay = personaward.awardname />
                  <#if personaward.awardlink?has_content>
                    <li><a href="${personaward.awardlink.link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${personaward.awardlink.link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${awardnameDisplay}"><span itemprop="award">${awardnameDisplay}</span></a></li>
                  <#else>
                  <li><span itemprop="award">${awardnameDisplay}</span></li>
                  </#if>

                  <#if personaward.awardingbody?has_content>
                    <#if personaward.awardingbodylink?has_content>
                      <a href="${personaward.awardingbodylink.link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${personaward.awardingbodylink.link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${personaward.awardingbody}">${personaward.awardingbody}</a>
                    <#else>
                      ${personaward.awardingbody}
                    </#if>
                  </#if>


                  <#if personaward.awardpicture?has_content>
                    <div class="awardpicture--div">
                      <@hst.link var="pic" hippobean=personaward.awardpicture.original fullyQualified=true />
                      <img src="${pic}" alt="Award image" />
                    </div>
                  </#if>

                </div>
              </#list>
            </ul>
          </#if>
        </p>

    </div>
    </#if>
  </#macro>
