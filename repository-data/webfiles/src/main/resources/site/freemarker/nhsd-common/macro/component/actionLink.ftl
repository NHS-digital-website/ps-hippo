<#ftl output_format="HTML">

<#include "../svgIcons.ftl">

<#macro actionLink title="Action link" link="#">
    <div class="action-link">
        <a class="action-link__link" href="${link}">
            <@svgIcon id="actionArrow" className="action-link__icon" />
            <span class="action-link__text">${title}</span>
        </a>
    </div>
</#macro>
