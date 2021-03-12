<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

<#macro headerMetadata metadataSet doctype>
    <#if metadataSet?? && metadataSet?has_content >
        <div class="column column--reset">
            <div class="detail-list-grid">

              <#list metadataSet as data>

                  <#assign uipath = data.uipath?has_content?then('data-uipath=${data.uipath}','') />
                  <#assign itempropProp = data.schemaOrgTag?has_content?then('itemprop=${data.schemaOrgTag}','') />

                  <div class="grid-row">
                      <div class="column column--reset">

                          <dl class="detail-list">

                            <dt class="detail-list__key">${data.key}:</dt>

                            <dd class="detail-list__value" ${uipath}>
                                <#if data.type?? >
                                    <#if data.type == "date" >
                                        <#assign datePattern = (doctype=="cyberalert")?then('d MMMM yyyy h:mm a','d MMMM yyyy')/>
                                      <span ${itempropProp}><@fmt.formatDate value=data.value type="Date" pattern="${datePattern}" timeZone="${getTimeZone()}" /></span>
                                    <#elseif data.type == "list" >
                                      <span ${itempropProp}><#list data.value as tag>${tag}<#sep>, </#list></span>
                                    <#elseif data.type == "link" >
                                      <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, data.value.title) />
                                      <a href="<@hst.link hippobean=data.value/>" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)"><span ${itempropProp}>${data.value.title}</span></a>
                                    <#elseif data.type == "twitterHashtag">
                                       <#list data.value as oldtag>
                                         <#if ! oldtag?starts_with("#")>
                                             <#assign tag = "#" + oldtag>
                                         <#else>
                                             <#assign tag = oldtag>
                                         </#if>
                                         <a href="https://twitter.com/search?q=${tag?replace('#','%23')}" target="blank_">${tag}</a><#sep>,
                                       </#list>
                                    <#else>
                                        <span ${itempropProp}>${data.value}</span>
                                    </#if>
                                <#else>
                                    <span ${itempropProp}>${data.value}</span>
                                </#if>
                            </dd>

                          </dl>

                      </div>
                  </div>
              </#list>

            </div>
          </div>
      </#if>
</#macro>
