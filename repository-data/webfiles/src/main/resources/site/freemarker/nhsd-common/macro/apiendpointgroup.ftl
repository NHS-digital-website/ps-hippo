<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "hubBoxWithTitle.ftl">

<#macro apiendpointgroup endpoint>
  <#assign customid = endpoint.title?has_content?then("id=apiendpoint-${slugify(endpoint.title)}", '') />
  <div ${customid} class="article-section-separator apiendpointgroup--div">
      <@hubBoxAndTitle doc=endpoint linksfield=endpoint.apirequest />
  </div>
</#macro>
