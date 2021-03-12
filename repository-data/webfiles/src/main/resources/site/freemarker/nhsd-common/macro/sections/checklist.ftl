<#ftl output_format="HTML">

<#macro checklist section>
    <#assign widgetClass = 'check-list-widget' />
    <#if section.heading?has_content>
      <#assign widgetClass += ' check-list-widget--with-heading' />
    </#if>

    <div class="${widgetClass} navigationMarker-sub">
        <#if section.heading?has_content>
            <h3 class="check-list-widget__label" id="${slugify(section.heading)}" data-uipath="website.contentblock.checklist.heading">${section.heading}</h3>
        </#if>

        <#assign tickClass = 'check-list-widget--tick' />
        <#if section.icon?trim != 'Bullet' && !(section.icon?trim == 'Custom' && !section.customicon?has_content)>
          <#assign tickClass += ' check-list-widget--tick--no-bullet' />
        </#if>

        <ul class="check-list-widget__list ${tickClass}">
            <#list section.listentries as entry>
                <li>
                    <#if section.icon?trim == 'Tick'>
                    <img class="check-list-widget-icon" src="<@hst.webfile path="/images/icon/Icon-tick-v3_v2.svg"/>" alt="Tick Image">
                    <#elseif section.icon?trim == 'Cross'>
                    <img class="check-list-widget-icon" src="<@hst.webfile path="/images/icon/Icon-cross-v2_v2.svg"/>" alt="Cross Image">
                    <#elseif section.icon?trim == 'Custom' && section.customicon?has_content>
                        <@hst.link hippobean=section.customicon.original fullyQualified=true var="leadImage" />
                        <#if leadImage?ends_with("svg")>
                            <img src="${leadImage?replace("/binaries", "/svg-magic/binaries")}?colour=005eb8"
                                 alt="Custom image" class="check-list-widget-icon"/>
                        <#else>
                            <img src="${leadImage}" alt="Custom image"
                                 class="check-list-widget-icon"/>
                        </#if>
                    </#if>
                    <span><@hst.html hippohtml=entry contentRewriter=gaContentRewriter/></span>
                </li>
            </#list>
        </ul>
    </div>
</#macro>
