<#ftl output_format="HTML">

<#macro metaTags>
    <#assign siteTitle = "NHS Digital"/>
    <#assign pageTitle = 'Home - ' + siteTitle />
    <#assign siteSEOSummary = "We’re the national information and technology partner to the health and social care system using digital technology to transform the NHS and social care" />
    <#assign pageSEOSummary = siteSEOSummary />
    <#assign defaultMetaImage><@hst.webfile path="images/nhs-digital-logo-social.jpg" fullyQualified=true/></#assign>
    <#assign defaultTwitterImage = defaultMetaImage />

    <#if document?? && document.title??>
        <#assign pageTitle = document.title + ' - ' + siteTitle />
    </#if>
    <#if overridePageTitle?? >
        <#assign pageTitle = overridePageTitle + ' - ' + siteTitle />
    </#if>
    <#if document?? && document.seosummary?? && document.seosummary?has_content>
        <#noautoesc>
          <!-- strip HTML tags -->
          <#assign tempSEOSummary =  document.seosummary.content?replace('<[^>]+>','','r') />
          <#if tempSEOSummary?has_content>
            <#assign pageSEOSummary = tempSEOSummary />
          </#if>
        </#noautoesc>
    </#if>

    <#-- lead image to replace default (field name must be leadImage - see blog and general types -->
    <#if document?? && document.socialmediaimages?? && document.socialmediaimages?has_content &&
        (document.socialmediaimages.socialmediaimage?has_content || document.socialmediaimages.twitterimage?has_content)>
        <#if ! document.socialmediaimages.socialmediaimage?has_content>
          <@hst.link hippobean=document.socialmediaimages.twitterimage.original fullyQualified=true var="image" />
          <#assign defaultMetaImage = image />
          <#assign defaultTwitterImage = image />
        <#elseif ! document.socialmediaimages.twitterimage?has_content>
          <@hst.link hippobean=document.socialmediaimages.socialmediaimage.original fullyQualified=true var="image" />
          <#assign defaultMetaImage = image />
          <#assign defaultTwitterImage = image />
        <#else>
          <@hst.link hippobean=document.socialmediaimages.socialmediaimage.original fullyQualified=true var="socialimage" />
          <@hst.link hippobean=document.socialmediaimages.twitterimage.original fullyQualified=true var="twitterimage" />
          <#assign defaultMetaImage = socialimage />
          <#assign defaultTwitterImage = twitterimage />
        </#if>
    <#elseif document?? && document.leadimagesection?? && document.leadimagesection.leadImage?? && document.leadimagesection.leadImage?has_content>
        <@hst.link hippobean=document.leadimagesection.leadImage.original fullyQualified=true var="leadImage" />
        <#assign defaultMetaImage = leadImage />
        <#assign defaultTwitterImage = defaultMetaImage />
    <#elseif document?? && document.leadImage?? && document.leadImage?has_content>
        <@hst.link hippobean=document.leadImage.original fullyQualified=true var="leadImage" />
        <#assign defaultMetaImage = leadImage />
        <#assign defaultTwitterImage = defaultMetaImage />
    </#if>

    <#-- Generic meta tags -->
    <@hst.headContribution keyHint="metaTitle" category="genericMeta">
        <title>${pageTitle}</title>
    </@hst.headContribution>
    <@hst.headContribution keyHint="metaTitle2" category="genericMeta">
        <meta name="title" content="${pageTitle}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="metaDescription" category="genericMeta">
        <meta name="description" content="${pageSEOSummary}" />
    </@hst.headContribution>

    <#-- Facebook OG meta tags -->
    <@hst.headContribution keyHint="facebookMetaTitle" category="facebookMeta">
        <meta property="og:title" content="${pageTitle}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="facebookMetaSiteName" category="facebookMeta">
        <meta property="og:site_name" content="${siteTitle}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="facebookMetaDescription" category="facebookMeta">
        <meta property="og:description" content="${pageSEOSummary}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="facebookMetaImage" category="facebookMeta">
        <meta property="og:image" content="${defaultMetaImage}" />
    </@hst.headContribution>

    <#-- Twitter meta tags -->
    <@hst.headContribution keyHint="twitterMetaTitle" category="twitterMeta">
        <meta property="og:title" name="twitter:title" content="${pageTitle}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="twitterMetaDescription" category="twitterMeta">
        <meta property="og:description" name="twitter:description" content="${pageSEOSummary}" />
    </@hst.headContribution>
    <@hst.headContribution keyHint="twitterMetaImage" category="twitterMeta">
        <meta property="og:image" name="twitter:image" content="${defaultTwitterImage}" />
    </@hst.headContribution>
</#macro>
