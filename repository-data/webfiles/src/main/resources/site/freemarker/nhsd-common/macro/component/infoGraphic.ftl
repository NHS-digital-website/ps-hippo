<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">

<#macro infoGraphic graphic>
<#assign selectedColour = "" />
<#assign selectedColour = graphic.colour?trim />
<#if selectedColour == "Blue">
  <#assign colourClass = "ffcd60" />
<#elseif selectedColour == "White">
  <#assign colourClass = "005EB8" />
<#elseif selectedColour == "Light blue">
  <#assign colourClass = "005EB8" />
</#if>


  <div class="infographic-div">
    <div class="infographic infographic--${slugify(selectedColour)}">
        <@hst.link hippobean=graphic.icon var="imagePath" />
        <#if (imagePath)??>
            <div class="infographic__icon">
                <#if imagePath?ends_with("svg")>
                    <img src="${imagePath?replace("/binaries", "/svg-magic/binaries")}?colour=${colourClass}" alt="Image for infographic ${graphic.headline}" width="100" height="100" />
                <#else>
                    <img aria-hidden="true" src="${imagePath}" alt="Image for infographic ${graphic.headline}" width="100" height="100" />
                </#if>
            </div>
        </#if>
        <div class="infographic__body">
            <div class="infographic__title">${graphic.headline}</div>
            <div class="infographic__explanatory"><@hst.html hippohtml=graphic.explanatoryLine contentRewriter=gaContentRewriter/></div>
            <div class="infographic__footer"><@hst.html hippohtml=graphic.qualifyingInformation contentRewriter=gaContentRewriter/></div>
        </div>
    </div>
  </div>
</#macro>
