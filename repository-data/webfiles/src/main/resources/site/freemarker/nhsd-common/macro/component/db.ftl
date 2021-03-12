<#ftl output_format="HTML">

<#macro downloadBlock doc itemprop="">

    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, doc.title) />
    <div class="nhsd-m-download-card">
    <a href="<@hst.link hippobean=doc />"
       class="nhsd-a-box-link"
       onClick="${onClickMethodCall}"
       onKeyUp="return vjsu.onKeyUp(event)" ${itemprop}>
        <div class="nhsd-a-box nhsd-a-box--bg-light-grey">
           <div class="nhsd-m-download-card__image-box">
<span class="nhsd-a-document-icon">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><path fill="#FFFFFF" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z"/>
  <path fill="#425563" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z M3,2h33c0.5,0,1,0.5,1,1 v5H2V3C2,2.5,2.5,2,3,2z M36,44H3c-0.5,0-1-0.5-1-1V10h35v33C37,43.6,36.6,44,36,44z"/>
  <g>
	  <path fill="#425563" d="M26.7,35.6h-0.6v1.9h0.6c0.6,0,1.4-0.2,1.4-0.9C28.1,35.7,27.4,35.6,26.7,35.6z"/>
	  <path fill="#425563" d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.4,30.7,29,29,29z M16.9,38.5h-1.7 L14,33.2h0l-1.2,5.3h-1.7l-1.8-6.6h1.4l1.2,5.3h0l1.1-5.3h1.8l1.2,5.3h0l1.2-5.3h1.3L16.9,38.5z M23.4,38.5h-3.9v-6.6h3.9v1h-2.6 v1.6h2.4v1h-2.4v1.9h2.6V38.5z M27.1,38.5h-2.3v-6.6h2.3c0.9,0,2.1,0.2,2.1,1.7c0,0.8-0.5,1.3-1.3,1.5v0c0.9,0.1,1.5,0.7,1.5,1.5 C29.4,38.3,27.9,38.5,27.1,38.5z"/>
	  <path fill="#425563" d="M27.9,33.8c0-0.8-0.7-0.8-1.3-0.8h-0.5v1.6h0.5C27.2,34.6,27.9,34.4,27.9,33.8z"/>
  </g>
  <g fill="#768692">
    <rect x="24" y="14" width="7" height="2"/>
    <rect x="8" y="14" width="14" height="12"/>
    <rect x="24" y="17" width="7" height="2"/>
    <rect x="24" y="20" width="7" height="2"/>
  </g>
  <g>
    <rect x="4" y="4" width="2" height="2" fill="#009639"/>
    <rect x="7" y="4" width="2" height="2" fill="#FAE100"/>
    <rect x="10" y="4" width="2" height="2" fill="#B30F0F"/>
  </g></svg>

    
</span>
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
