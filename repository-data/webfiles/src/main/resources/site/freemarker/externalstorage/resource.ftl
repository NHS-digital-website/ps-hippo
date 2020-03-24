<#ftl output_format="HTML">

<#macro externalstorageLink item earlyAccessKey="">
    <#if item.class.name == "org.hippoecm.hst.content.beans.standard.HippoResource">
        <@hst.link var="url" hippobean=item>
            <#if earlyAccessKey?has_content><@hst.param name="key" value="${earlyAccessKey}"/></#if>
        </@hst.link>
    <#elseif hstRequestContext.preview>
        <@hst.link siteMapItemRefId="S3CONNECTOR-PIPELINE-ID" var="s3EndpointBaseUrl"/>
        <#assign url=s3EndpointBaseUrl + "/?s3Reference=" + item.referenceEncoded + "&fileName=" + item.filename/>
        <#if earlyAccessKey?has_content>
            <#assign url= url + "&key=" +earlyAccessKey />
        </#if>
    <#else>
        <#assign url=item.url/>
        <#if earlyAccessKey?has_content>
            <#assign url= url + "?key=" +earlyAccessKey />
        </#if>
    </#if>
    <#nested url>
</#macro>
