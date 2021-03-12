<#ftl output_format="HTML">
<#include "../documentIcon.ftl">

<#function sizeToDisplay size=0>
    <#assign sizeString = "${size} bytes" />
    <#if size gt 1000000>
    	<#assign sizemb = size/1000000 />
    	<#assign sizeString = "${sizemb?round} MB" />
    <#elseif size gt 1000>
    	<#assign sizekb = size/1000 />
    	<#assign sizeString = "${sizekb?round} KB" />
    </#if>

    <#return sizeString>
</#function>

<#macro downloadBlockAsset classname doc title shortsummary mimeType size=0>

    <#assign onClickMethodCall = getOnClickMethodCall(classname, title) />
    <#assign sizeString = sizeToDisplay(size) />
    <#assign iconTypeFromMime = getFormatByMimeType("${mimeType?lower_case}") />

    <div class="nhsd-m-download-card">
    <a href="<@hst.link hippobean=doc />" class="nhsd-a-box-link" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)" >
        <div class="nhsd-a-box nhsd-a-box--bg-light-grey">
            <div class="nhsd-m-download-card__image-box">
		<#-- macro to get the svg accepts type and size but size defaults to medium which is what we want -->
                <@documentIcon  "${iconTypeFromMime}"/>
            </div>
            <div class="nhsd-m-download-card__content-box">

               <#if title?has_content>
                 <h1 class="nhsd-t-heading-s">${title}</h1>
                 <p class="nhsd-t-body-s">${shortsummary}</p>
               </#if>
               <div class="nhsd-m-download-card__meta-tags">
                      <span class="nhsd-a-tag nhsd-a-tag--meta">${iconTypeFromMime}</span>
                      <span class="nhsd-a-tag nhsd-a-tag--meta-light">${sizeString}</span>
               </div>


               <span class="nhsd-a-icon nhsd-a-arrow nhsd-a-arrow--down nhsd-a-icon--size-s">
                  <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                     <path d="M15,8.5L8,15L1,8.5L2.5,7L7,11.2L7,1l2,0l0,10.2L13.5,7L15,8.5z"/>
                  </svg>
               </span>
             </div>
      </div>
    </a>
    </div>
</#macro>
