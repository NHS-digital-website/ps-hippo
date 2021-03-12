<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.LawfulBasis" -->

<#include "../../include/imports.ftl">

  <#macro lawfulbasis section>
    <div class="lawfulbasis--div">
      <h3>${section.description}</h3>
    </div>
  </#macro>
