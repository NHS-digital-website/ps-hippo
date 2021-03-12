<#ftl output_format="HTML">

<#macro emphasisBox section>
    <#if section?is_string >
      <#assign slug = 'emphasis-' + section.emphasisType + '-' + section?keep_after('@') />
    <#else>
      <#assign slug = 'emphasis-' + section.emphasisType />
    </#if>

    <#if section.heading?has_content && slug??>
        <#assign ariaAttribute = 'aria-labelledby' />
        <#assign ariaValue = slugify(slug) />
    <#else>
        <#assign ariaAttribute = 'aria-label' />
        <#assign ariaValue = section.heading />
        <#if section.emphasisType == 'Warning'>
            <#assign ariaValue = 'Warning' />
        <#elseif section.emphasisType == 'Important'>
            <#assign ariaValue = 'Important Information' />
        <#elseif section.emphasisType == 'Emphasis'>
            <#assign ariaValue = 'Highlighted Information' />
        <#elseif section.emphasisType == 'Note'>
            <#assign ariaValue = 'Information' />
        </#if>
    </#if>

    <div class="emphasis-box emphasis-box-${slugify(section.emphasisType)} navigationMarker-sub" ${ariaAttribute}="${ariaValue}">
        <#if section.image??>
            <div class="emphasis-box__image">
                <@hst.link hippobean=section.image fullyQualified=true var="iconImage" />
                <#if iconImage?ends_with("svg")>
                    <img src="${iconImage?replace("/binaries", "/svg-magic/binaries")}?colour=005eb8" alt="${section.heading}" width="100" height="100" />
                <#else>
                    <img src="${iconImage}" alt="${section.heading}" width="100" height="100" />
                </#if>
            </div>
        </#if>

        <div class="emphasis-box__content">
            <#if section.heading?has_content && slug??>
                <strong role="heading" class="emphasis-box__heading" id="${slugify(slug)}" data-uipath="website.contentblock.emphasis.heading">${section.heading}</strong>
            </#if>

            <#if section.body?? && section.body.content?has_content>
                <div data-uipath="website.contentblock.emphasis.content"><@hst.html hippohtml=section.body contentRewriter=gaContentRewriter /></div>
            <#elseif section.bodyCustom??>
                <div data-uipath="website.contentblock.emphasis.content">${section.bodyCustom}</div>
            </#if>
        </div>
    </div>
</#macro>
