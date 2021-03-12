<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

  <#macro contactdetail contactdetails='' idsuffix='' name='' email='' phone='' title="Contact details" isSchemaOrg=true>
    <#if contactdetails='' || (contactdetails?has_content && (contactdetails.emailaddress?has_content || contactdetails.phonenumber?has_content)) >
      <div id="contactdetail-${slugify(idsuffix)}" class="contactdetail--div article-section">
        <h2>${title}</h2> 

        <#assign rendername=name /><#if contactdetails != '' && contactdetails.name?has_content><#assign rendername=contactdetails.name /></#if>
        <#assign renderemail=email /><#if contactdetails != '' && contactdetails.emailaddress?has_content><#assign renderemail=contactdetails.emailaddress /></#if>
        <#assign renderphone=phone /><#if contactdetails != '' && contactdetails.phonenumber?has_content><#assign renderphone=contactdetails.phonenumber /></#if>

        <div class="contactdetail-box">
          <#if rendername != ''>
            <div class="contactdetail-item-bold"><span>${rendername}</span></div>
          </#if>

          <#if contactdetails != '' && contactdetails.purpose?has_content>
            <div class="contactdetail-item">Purpose: ${contactdetails.purpose}</div>
          </#if>
          <#if contactdetails != '' && contactdetails.description?has_content>
            <div class="contactdetail-item">Description of contact point: ${contactdetails.description}</div>
          </#if>

          <#if renderemail != ''>
            <div class="contactdetail-item">Email: 
              <#if isSchemaOrg>
                <a href="mailto:${renderemail}" itemprop="email" class="contactdetail-item">${renderemail}</a>
              <#else>
                <a href="mailto:${renderemail}" class="contactdetail-item">${renderemail}</a>
              </#if>
            </div>
          </#if>
          <#if renderphone != ''>
            <div class="contactdetail-item">Phone: 
              <#if isSchemaOrg>
                <a href="tel:${renderphone?replace(" ","")?replace("-","")}" itemprop="telephone" class=contactdetail-item>${renderphone}</a>
              <#else>
                <a href="tel:${renderphone?replace(" ","")?replace("-","")}" class=contactdetail-item>${renderphone}</a>
              </#if>
            </div>
          </#if>

          <#if contactdetails != '' && contactdetails.twitterHandle?has_content>
            <#assign twitterhandle = contactdetails.twitterHandle />
            <#if twitterhandle?substring(0, 1) == "@">
              <#assign twitterhandle = contactdetails.twitterHandle?substring(1) />
            </#if>
            <#assign twitterlink = "https://twitter.com/" + twitterhandle />


            <div class="contactdetail-item">Twitter handle: 
                <a href="${twitterlink}" onClick="logGoogleAnalyticsEvent('Link click',document.class.name,'${twitterlink}');" onKeyUp="return vjsu.onKeyUp(event)"  title="${twitterhandle}" target="_blank">@${twitterhandle}</a>
            </div>
          </#if>

          <#if contactdetails != '' && contactdetails.webchatDescription?has_content>
            <div class="contactdetail-item">Webchat description: ${contactdetails.webchatDescription}</div>
          </#if>

          <#if contactdetails != '' && contactdetails.webchatLink?has_content>
            <div class="contactdetail-item">Webchat link: 
                <a href="${contactdetails.webchatLink}" class=contactdetail-item>${contactdetails.webchatLink}</a>
            </div>
          </#if>

          <#if contactdetails != '' && contactdetails.webformDescription?has_content>
            <div class="contactdetail-item">Webform description: ${contactdetails.webformDescription}</div>
          </#if>

          <#if contactdetails != '' && contactdetails.webformLink?has_content>
            <div class="contactdetail-item">Webform link: 
                <a href="${contactdetails.webformLink}" class=contactdetail-item>${contactdetails.webformLink}</a>
            </div>
          </#if>

        </div>
      </div>
    </#if>
  </#macro>
