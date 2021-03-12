<#ftl output_format="HTML">

<#include "../../include/imports.ftl">
<#include "headerMetadata.ftl">

<#macro documentHeader document doctype header_icon_arg='' title="" summary="" topics="" hasSchemaOrg=true metadata={} downloadPDF=false>

    <#assign custom_title = title />
    <!-- checking whether simulating doc in order to avoid console errors from NewsHub and EventHub docs -->
    <#if ! custom_title?has_content && document != "simulating_doc"  >
      <#assign custom_title = document.title />
    </#if>

    <#assign custom_summary = summary />
    <#assign hasDocumentSummary = false />
    <#if ! custom_summary?has_content && document != "simulating_doc"  >
      <#assign hasDocumentSummary = document.summary?? && document.summary.content?has_content />
      <#if hasDocumentSummary >
        <#assign custom_summary = document.summary />
      </#if>
    </#if>

    <#assign hasBannerControls = document != "simulating_doc" && document.bannercontrols?? && document.bannercontrols?has_content />
    <#assign hasPageIcon = document != "simulating_doc" && document.pageIcon?? && document.pageIcon?has_content />

    <#assign headerIcon = header_icon_arg>
    <#if ! header_icon_arg?has_content>
      <#if hasBannerControls && document.bannercontrols.icon?has_content>
        <#assign headerIcon = document.bannercontrols.icon />
      <#elseif hasPageIcon>
        <#assign headerIcon = document.pageIcon />
      </#if>
    </#if>

    <#assign hasFinalPageIcon = headerIcon?has_content />
    <#assign hasTopics = topics?has_content />

    <#assign headerStyle='' />
    <#if hasBannerControls && document.bannercontrols.backgroundcolor?has_content>
      <#assign headerStyle = 'style=background-color:${document.bannercontrols.backgroundcolor}' />
    </#if>

    <#if hasBannerControls && document.bannercontrols.fontcolor?has_content>
    <#assign headerStyle = '${headerStyle}${headerStyle?has_content?then(";","style=")}color:${document.bannercontrols.fontcolor}' />
    </#if>

    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide" aria-label="Document Header">
        <div class="local-header article-header article-header--with-icon" ${headerStyle}>
            <div class="grid-wrapper">
                <div class="article-header__inner">
                    <div class="grid-row">
                        <div class="column--two-thirds column--reset" itemscope itemtype="http://schema.org/Text">

                            <#if doctype == "news">
                              <span class="article-header__label">${doctype?capitalize}</span>
                            </#if>

                            <#assign titleProp = "itemprop=name">
                            <#if hasSchemaOrg>
                              <#assign titleProp = "itemprop=name">
                              <#if doctype == "news">
                                  <#assign titleProp = "itemprop=headline">
                              </#if>
                            </#if>

                            <h1 id="top" class="local-header__title" data-uipath="document.title" ${hasSchemaOrg?then(titleProp, '')} ${headerStyle}>${custom_title}</h1>
                            <#if hasDocumentSummary>
                              <div class="article-header__subtitle" data-uipath="website.${doctype}.summary">
                                <@hst.html hippohtml=custom_summary contentRewriter=gaContentRewriter/>
                              </div>
                            <#else>

                              <#assign schemaProp = "" />
                              <#if hasSchemaOrg>
                                <#assign schemaProp = "itemprop=description" />
                              </#if>

                                <#if custom_summary?has_content>
                                    <div ${schemaProp} class="article-header__subtitle" data-uipath="website.${doctype}.summary">${custom_summary}</div>
                                </#if>
                            </#if>

                            <#if doctype == "intranet-task">
                                <#if document.introduction?has_content>
                                    <div class="rich-text-content article-header__subtitle">
                                        <@hst.html hippohtml=document.introduction contentRewriter=gaContentRewriter />
                                    </div>
                                </#if>

                                <#if document.priorityActions?has_content>
                                    <div class="ctabtn--div">
                                        <#list document.priorityActions as action>
                                            <#if action.link.linkType == "internal">
                                                <@hst.link hippobean=action.link.link var="priorityActionLink"/>
                                            <#else>
                                                <#assign priorityActionLink=action.link.link/>
                                            </#if>
                                            <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, action.action) />
                                            <div class="ctabtn--inline" aria-labelledby="ctabtn-${slugify(action.action)}">
                                                <a href="${priorityActionLink}"
                                                   class="ctabtn--white-button"
                                                   id="ctabtn-${slugify(action.action)}"
                                                   onClick="${onClickMethodCall}"
                                                   onKeyUp="return vjsu.onKeyUp(event)">
                                                    ${action.action}
                                                </a>
                                            </div>
                                        </#list>
                                    </div>
                                </#if>
                            </#if>
                        </div>
                        <#if hasFinalPageIcon>
                            <div class="column--one-third column--reset local-header__icon">
                              <#if hasBannerControls && document.bannercontrols.icon?has_content || document != "simulating_doc" && hasPageIcon >
                                  <#-- ex. Service case - image from HippoGalleryImageSet -->
                                  <@hst.link hippobean=headerIcon.original fullyQualified=true var="image" />
                                  <#if image?ends_with("svg")>
                                      <#assign colour = 'ffcd60'>
                                      <#if hasBannerControls && document.bannercontrols.iconcolor?has_content>
                                        <#assign colour = document.bannercontrols.iconcolor?replace("#","")>
                                      </#if>
                                      <#assign imageUrl = '${image?replace("/binaries", "/svg-magic/binaries")}' />
                                      <#assign imageUrl += "?colour=${colour}" />
                                      <img src="${imageUrl}" alt="${custom_title}" aria-hidden="true" />
                                  <#else>
                                      <img src="${image}" alt="${custom_title}" aria-hidden="true" />
                                  </#if>
                              <#else>
                                <#-- ex. EventsHub or NewsHub case - image from provided path -->
                                <img src="<@hst.webfile path="${headerIcon}" fullyQualified=true/>" alt="${custom_title}" aria-hidden="true">
                              </#if>
                            </div>
                        </#if>
                    </div>

                    <#if hasTopics>
                      <div class="detail-list-grid">
                        <div class="grid-row">
                            <div class="column column--reset">
                                <dl class="detail-list">
                                    <dt class="detail-list__key">Topics:</dt>
                                    <dd class="detail-list__value">
                                      <#if hasSchemaOrg>
                                        <span itemprop="keywords" ><#list document.taxonomyTags as tag>${tag} <#sep>, </#list></span>
                                      <#else>
                                        <span><#list document.taxonomyTags as tag>${tag} <#sep>, </#list></span>
                                      </#if>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                      </div>
                    </#if>
                </div>

                <@headerMetadata metadata doctype />

                <#if downloadPDF>
                    <div class="grid-row">
                        <div class="column column--reset">
                            <button type="button" class="cta-btn cta-btn--white top-margin-20 is-hidden-if-no-js" id="print-pdf-button"><@fmt.message key="labels.download-pdf"/></button>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </div>

</#macro>
