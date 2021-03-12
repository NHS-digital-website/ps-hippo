<#ftl output_format="HTML">
<#include "sections/expander.ftl">

<#macro editorsnotes notes>
  <#list notes as note>
    <#if note.editorsnote?has_content>
      <div class="article-section">
        <div class="rich-text-content">
            <@expander "" "Notes for editors" note.editorsnote />
        </div>
      </div>
    </#if>
  </#list>
</#macro>
