<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.SociaMedia" -->

<#include "../../include/imports.ftl">
<#include "othersocialmedia.ftl">

  <#macro socialmedia section>
    <div class="socialmedia--div">
      <h3>${section.linkedinlink}</h3>
      <h3>${section.twitteruser}</h3>
    </div>
  </#macro>
