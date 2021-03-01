<#ftl output_format="HTML">
<#include "./macro/nhsd/header-banner.ftl">

<#assign banner1 = {
    text: button1Text,
    url: button1Url
}/>

<#assign banner2 = {
    text: button2Text,
    url: button2Url
}/>

<#if banner??>
    <div class="nhsd-!t-margin-bottom-9">
        <@headerBanner banner banner1 banner2 color alignment digiblockposition />
    </div>
</#if>
