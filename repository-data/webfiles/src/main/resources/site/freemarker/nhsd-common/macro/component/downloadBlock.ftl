<#ftl output_format="HTML">
<#include "../documentIcon.ftl">

<#macro downloadBlock doc itemprop="">

    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, doc.title) />
    <div class="nhsd-m-download-card">
    <a href="<@hst.link hippobean=doc />" class="nhsd-a-box-link" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)" ${itemprop}>
        <div class="nhsd-a-box nhsd-a-box--bg-light-grey">
            <div class="nhsd-m-download-card__image-box">
		<#-- macro to get the svg accepts type and size but size defaults to medium which is what we want -->
                <@downloadIcon "pdf" />
            </div>
            <div class="nhsd-m-download-card__content-box">
               <span class="nhsd-a-tag nhsd-a-tag--bg-dark-grey">ARTICLE</span>

               <#if doc.shortsummary?has_content>
                 <h1 class="nhsd-t-heading-s">${doc.title}</h1>
                 <p class="nhsd-t-body-s">${doc.shortsummary}</p>
               </#if>
               <span class="nhsd-a-icon nhsd-a-arrow nhsd-a-arrow--right nhsd-a-icon--size-s">
                  <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                     <path d="M8.5,15L15,8L8.5,1L7,2.5L11.2,7H1v2h10.2L7,13.5L8.5,15z"/>
                  </svg>
               </span>
             </div>
      </div>
    </a>
    </div>
</#macro>
