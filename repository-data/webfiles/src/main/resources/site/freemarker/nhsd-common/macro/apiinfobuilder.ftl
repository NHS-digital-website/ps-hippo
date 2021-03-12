<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "hubBoxWithTitle.ftl">

<#macro apiinfobuilder builder>
  <#assign customid = builder.title?has_content?then("id=apiinfobuilder-${slugify(builder.title)}", '') />
  <div ${customid} class="article-section-separator apiinfobuilder--div">
      <@hubBoxAndTitle doc=builder linksfield=builder.content/>
  </div>
</#macro>
