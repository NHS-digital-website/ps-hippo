<#ftl output_format="HTML">

<#macro visualhubBox link>

    <#if link.title??>
        <#assign title = link.title>
    </#if>
    <#if link.summary??>
        <#assign summary = link.summary>
    </#if>
    <#if link.linkType == "internal">
        <#assign title = link.link.title>
    <#elseif link.linkType == "external">
        <#assign summary = link.shortsummary>
    </#if>

    <div class="visual-hub-box">
        <div class="visual-hub-box-content" >
            <#if link.linkType == "internal">
            <#-- Below does not work if declared in section above -->
                <a href="<@hst.link hippobean=link.link />">
            <#elseif link.linkType == "external">
                <a href="${link.link}" onKeyUp="return vjsu.onKeyUp(event)">
            <#elseif link.linkType == "asset">
                <a href="<@hst.link hippobean=link.link onKeyUp="return vjsu.onKeyUp(event)" />">
            </#if>
                <div class="visual-hub-box-content${((link.icon.original)??)?then('-text', '-full-text')}">
                    <h2>${title}</h2>
                    ${summary}
                </div>
                 <#if (link.icon.original)??>
                     <@hst.link var="icon" hippobean=link.icon.original fullyQualified=true />
                     <#if icon?ends_with("svg")>
                        <img src="${icon?replace("/binaries", "/svg-magic/binaries")}?colour=005eb8" alt="${title}" class="visual-hub-box-content-img" />
                    <#else>
                        <img src="${icon}" alt="${title}" class="visual-hub-box-content-img" />
                    </#if>
                </#if>
            </a>
        </div>
    </div>

</#macro>
