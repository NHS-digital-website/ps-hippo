<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#include "../../publicationsystem/macro/structured-text.ftl">

<@hst.setBundle basename="publicationsystem.labels,publicationsystem.headers"/>

<#assign hasIntroductionContent = document.introduction?? && document.introduction.content?has_content />

<#macro releaseInfo article>
    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide" aria-label="Document Header">
        <div class="local-header article-header article-header--detailed">
            <div class="grid-wrapper">
                <div class="article-header__inner">

                  <div class="column column--two-thirds page-block page-block--main">

                    <div>
                      <h1 id="top" class="local-header__title-left" data-uipath="article.title" itemprop="name">${article.title}</h1>

                      <div class="local-header__tag">${releasestatuses[document.releaseinfos.releasestatus]?upper_case}</div>

                      <#if article.apiservice?has_content>
                          <p class="article-header__subtitle" itemprop="isPartOf" itemscope itemtype="http://schema.org/Series">
                              This is part of
                              <#list article.apiservice as service>
                                <@hst.link hippobean=service var="apiservice"/>
                                <a itemprop="url" href="${apiservice}" onClick="logGoogleAnalyticsEvent('Link click','Person','${apiservice}');" onKeyUp="return vjsu.onKeyUp(event)" title="${service.title}"><span itemprop="name">${service.title}</span></a><#sep>,
                              </#list>
                          </p>
                      </#if>
                    </div>

                    <#if hasIntroductionContent>
                        <div class="article-header__subtitle" data-uipath="article.introduction"><@hst.html hippohtml=article.introduction contentRewriter=gaContentRewriter/></div>
                    </#if>

                    <div class="detail-list-grid">

                      <meta itemprop="keywords" content="${article.getFullTaxonomyList()?join(",")}"/>

                      <#if article.releaseinfos?has_content>

                           <#assign releaseinfo = article.releaseinfos />

                            <#if releaseinfo.releasedate?has_content>
                              <div class="grid-row">
                                  <div class="column column--reset">
                                      <dl class="detail-list">
                                          <dt class="detail-list__key" id="release-date-${slugify(article.title)}">Release date: </dt>
                                          <dd class="detail-list__value" data-uipath="article.releaseinfo.releasedate" itemprop="dateReleased">
                                              <@fmt.formatDate value=releaseinfo.releasedate.time?date type="date" pattern="d MMM yyyy" timeZone="${getTimeZone()}" />
                                          </dd>
                                      </dl>
                                  </div>
                              </div>
                            </#if>

                            <#if releaseinfo.version?has_content || releaseinfo.otherversionreference?has_content>
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list detail-list__flex">
                                            <dt class="detail-list__key" id="release-version-${slugify(article.apiname)}">Release version: </dt>
                                            <dd class="detail-list__value" itemprop="versionReleased" data-uipath="article.releaseinfo.release-version">
                                            <#if releaseinfo.version?has_content >
                                              ${releaseinfo.version}
                                              <#if releaseinfo.otherversionreference?has_content >
                                                ,
                                              </#if>
                                            </#if>
                                            <#if releaseinfo.otherversionreference?has_content >
                                              ${releaseinfo.otherversionreference}
                                            </#if>


                                            <#if releaseinfo.replacementlink?has_content >
                                                 - This is not the latest version of this API.
                                                <#list releaseinfo.replacementlink as link>
                                                  <#if link.linkType == "internal">
                                                    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, link.link.title) />
                                                    <a href="<@hst.link hippobean=link.link />"
                                                       onClick="${onClickMethodCall}"
                                                       onKeyUp="return vjsu.onKeyUp(event)">
                                                        See the latest version
                                                    </a>
                                                  <#elseif link.linkType == "external">
                                                    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, link.link) />
                                                    <a href="${link.link}"
                                                       onClick="${onClickMethodCall}"
                                                       onKeyUp="return vjsu.onKeyUp(event)">
                                                        See the latest version
                                                     </a>
                                                   </#if>
                                                </#list>
                                            </#if>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>

                            <#if releaseinfo.effectivedate?has_content >
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list">
                                            <dt class="detail-list__key">Effective date: </dt>
                                            <dd class="detail-list__value" data-uipath="article.releaseinfo.effective-date">
                                                <@fmt.formatDate value=releaseinfo.effectivedate.time?date type="date" pattern="d MMM yyyy" timeZone="${getTimeZone()}" />
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>


                            <#if releaseinfo.changesummary?has_content >
                                <div class="grid-row">
                                    <div class="column column--reset">
                                        <dl class="detail-list">
                                            <dt class="detail-list__key">Change summary: </dt>
                                            <dd class="detail-list__value" data-uipath="article.releaseinfo.change-summary">
                                              ${releaseinfo.changesummary}
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </#if>

                      </#if>
                    </div>
                  </div>
                </div>
            </div>
        </div>
    </div>
</#macro>
