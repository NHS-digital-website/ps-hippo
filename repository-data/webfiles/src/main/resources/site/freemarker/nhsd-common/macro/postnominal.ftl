<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Postnominal" -->

<#include "../../include/imports.ftl">

  <#macro postnominal section>
    <div class="postnominal--div">
      <h3>${section.title}</h3>
      <p>${section.content}</p>
      <h3>${section.type}</h3>
    </div>
  </#macro>
