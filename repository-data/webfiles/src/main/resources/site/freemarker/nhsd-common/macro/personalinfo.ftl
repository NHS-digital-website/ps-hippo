<#ftl output_format="HTML">

<#-- @ftlvariable name="document" type="uk.nhs.digital.website.beans.PersonalInfo" -->

<#include "../../include/imports.ftl">

  <#macro personalinfo>
    <div class="personalinfo--div">
      <h3>${document.firstname}</h3>
    </div>
  </#macro>
