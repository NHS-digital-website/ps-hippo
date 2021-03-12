<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.OtherSocialMedia" -->

<#include "../../include/imports.ftl">

  <#macro othersocialmedia section>
    <div class="othersocialmedia--div">
      <h3>${section.title}</h3>
      <h3>${section.link}</h3>
    </div>
  </#macro>
