<#ftl output_format="HTML">

<#include "../../../include/imports.ftl">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.CtaButton" -->

  <#macro ctaSection section>
    <#list section.items as ctalink>
        <#if ctalink.linkType == "internal">
        <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, ctalink.link.title) />
          <div class="ctabtn--div">
            <div class="ctabtn-${slugify(section.alignment)}" aria-labelledby="ctabtn-${slugify(section.title)}">
              <a href="<@hst.link hippobean=ctalink.link />"
                class="ctabtn-${slugify(section.alignment)} ctabtn--${slugify(section.buttonType)}" 
                id="ctabtn-${slugify(section.title)}" 
                onClick="${onClickMethodCall}"
                onKeyUp="return vjsu.onKeyUp(event)">
                ${section.title}
              </a>
            </div>
          </div>
        <#elseif ctalink.linkType == "external">
          <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, ctalink.link) />
          <div class="ctabtn--div">
            <div class="ctabtn-${slugify(section.alignment)}" aria-labelledby="ctabtn-${slugify(section.title)}">
              <a href="${ctalink.link}"
                class="ctabtn-${slugify(section.alignment)} ctabtn--${slugify(section.buttonType)}" 
                id="ctabtn-${slugify(section.title)}" 
                onClick="${onClickMethodCall}"
                onKeyUp="return vjsu.onKeyUp(event)">
                ${section.title}
              </a>
            </div>
          </div>
        </#if>
    </#list>
  </#macro>
