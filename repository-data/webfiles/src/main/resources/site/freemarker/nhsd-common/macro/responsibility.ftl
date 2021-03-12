<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

  <#macro responsibility resp idsuffix firstname manages="" managedby="">
    <#if
     resp?? && resp?has_content && (resp.responsible?has_content || resp.responsibleforservice?has_content) ||
     manages?has_content ||
     managedby?has_content
    >
      <div id="responsibility-${slugify(idsuffix)}" class="responsibility--div article-section">
        <h2>Responsibilities</h2>

        <#if resp.responsible?has_content>
          <p data-uipath="person.responsibilities">
              ${firstname} has responsibility for:
              <ul>
                <#list resp.responsible as responsibility>
                  <li>${responsibility}</li>
                </#list>
              </ul>
          </p>
        </#if>

        <#if resp.responsibleforservice?has_content>
          <p data-uipath="person.responsibleforservice">
              ${firstname} is responsible for:
              <ul>
                <#list resp.responsibleforservice as service>
                  <@hst.link hippobean=service var="link" />
                  <li><a href="${link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${service.title}">${service.title}</a></li>
                </#list>
              </ul>
          </p>
        </#if>

        <#if manages?has_content>
          <p data-uipath="person.manages">
              ${firstname} manages:
              <ul>
                <#list manages as managee>
                  <#assign pinfo = managee.personalinfos />
                  <#assign displayName = pinfo.preferredname?has_content?then(pinfo.preferredname, pinfo.firstname + " " + pinfo.lastname) />
                  <#assign personrole = ''>
                  <#if managee.roles?has_content && managee.roles.primaryroles?has_content>
                    <#assign personrole = ', ' + managee.roles.firstprimaryrole />
                  </#if>
                  <@hst.link hippobean=managee var="link" />
                  <li><a href="${link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${link}');" onKeyUp="return vjsu.onKeyUp(event)" title="${displayName}${personrole}">${displayName}${personrole}</a></li>
                </#list>
              </ul>
          </p>
        </#if>

        <#if managedby?has_content>
          <p data-uipath="person.managedby">
              <#assign pinfo = managedby.personalinfos />
              <#assign displayName = pinfo.preferredname?has_content?then(pinfo.preferredname, pinfo.firstname + " " + pinfo.lastname) />
              <#assign personrole = ''>
              <#if managedby.roles?has_content && managedby.roles.primaryroles?has_content>
                <#assign personrole = ', ' + managedby.roles.firstprimaryrole />
              </#if>
              ${firstname} is managed by:
              <ul>
                <@hst.link hippobean=managedby var="link" />
                <li><a href="${link}" onClick="logGoogleAnalyticsEvent('Link click','Person','${link}');" onKeyUp="return vjsu.onKeyUp(event)" :title="${displayName}${personrole}">${displayName}${personrole}</a></li>
              </ul>
          </p>
        </#if>
      </div>
      </#if>
  </#macro>
