<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

  <#macro qualification quals idsuffix firstname>
    <#if quals?has_content>
    <div id="qualification-${slugify(idsuffix)}" class="qualification--div article-section">
      <h2>Qualifications</h2> 

        <p>
          <#if quals?has_content >
            ${firstname} is qualified for:
            <ul>
              <#list quals as qual>
                <div>
                  <#assign qualnameDisplay = qual.qualname />
                  <#if qual.quallink?has_content>
                    <li><a href="${qual.quallink.link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${qual.quallink.link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${qualnameDisplay}">${qualnameDisplay}</a></li>
                  <#else>
                    <li>${qualnameDisplay}</li>
                  </#if>

                  <#if qual.qualawardingbody?has_content>
                    <#if qual.qualawardingbodylink?has_content>
                      <a href="${qual.qualawardingbodylink.link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${qual.qualawardingbodylink.link}');" onKeyUp="return vjsu.onKeyUp(event)"  title="${qual.qualawardingbody}">${qual.qualawardingbody}</a>
                    <#else>
                      ${qual.qualawardingbody}
                    </#if>
                  </#if>

                  <#if qual.qualificationlogo?has_content>
                    <div class="quallogo--div">
                      <@hst.link var="quallogo" hippobean=qual.qualificationlogo.original fullyQualified=true />
                      <img src="${quallogo}" alt="Qualification logo" />
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
