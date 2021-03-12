<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "hubBox.ftl">

<#macro hubBoxAndTitle doc linksfield>
            <div class="column">
              <div class="column column--one-third page-block page-block--sidebar article-section-nav-outer-wrapper">
                <h2>${doc.title}</h2>
              </div>
              <div class="page-block--main-alignment column column--two-thirds page-block page-block--main">
                <div class="column column--reset">
                  <div class="hub-box-list">
                    <#list linksfield as link>

                      <#if link?? && !link.linkType?? > 

                        <#-- special case for apiendpointgroup -->

                        <#assign title = "">
                        <#assign apimethod = "">

                        <#if link.requestname??>
                          <#assign title = link.requestname>
                          <#if link.apimethod??>
                            <#assign apimethod = link.apimethod?lower_case>
                          </#if>
                          <#if link.releasestatus == 'deprecated' || link.releasestatus == 'retired'>
                            <#assign title = link.releasestatus?capitalize + ": " + title>
                          </#if>
                        </#if>

                        <#assign boxdata = { "title": title, "text": link.shortsummary } />
                        <@hst.link hippobean=link var="boxlink"/>
                        <#assign boxdata += { "link": boxlink } />
                        <#assign boxdata += { "colorbox": apimethod } />

                      <#elseif link.linkType == "internal">

                        <#assign title = link.link.title?has_content?then(link.link.title, '')>
                        <#assign text = link.link.shortsummary?has_content?then(link.link.shortsummary, '')>

                        <#assign boxdata = { "title": title, "text": text } />
                        <@hst.link hippobean=link.link var="boxlink" />
                        <#assign boxdata += { "link": boxlink } />
                      <#elseif link.linkType == "external">

                        <#assign title = link.title?has_content?then(link.title, '')>
                        <#assign text = link.shortsummary?has_content?then(link.shortsummary, '')>

                        <#assign boxdata = { "title": title, "text": text } />
                        <#assign boxdata += { "link": link.link } />
                      </#if>

                      <@hubBox boxdata></@hubBox>

                    </#list>
                  </div>
                </div>
              </div>
          </div>
</#macro>

