<#ftl output_format="HTML">

<#macro relatedLinkSection section>
    <div data-uipath="ps.publication.relatedlink-section">
        <a data-uipath="ps.publication.relatedlink-section.text" target="_blank"
           href="${section.linkUrl}" onClick="logGoogleAnalyticsEvent('Link click','Publication','${section.linkUrl}');" onKeyUp="return vjsu.onKeyUp(event)">${section.linkText}</a>
    </div>
</#macro>
