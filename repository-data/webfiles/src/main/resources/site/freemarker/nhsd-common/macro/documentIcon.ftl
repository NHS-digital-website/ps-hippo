<#ftl output_format="HTML">

<#include "../../include/imports.ftl">

<#macro documentIcon icontype="web" size="medium">
<#-- default is medium -->
<#-- as far as I can see the svg's for different sizes are identical apart from the class -->


  <#assign sizeClass = "" />
  <#if size == "large">
  	<#assign sizeClass = "nhsd-a-document-icon--size-l" />
  <#elseif size == "small">
  	<#assign sizeClass = "nhsd-a-document-icon--size-s" />
  </#if>
  
      <#if icontype == "web" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><path fill="#FFFFFF" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z"></path>
  <path fill="#425563" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z M3,2h33c0.5,0,1,0.5,1,1 v5H2V3C2,2.5,2.5,2,3,2z M36,44H3c-0.5,0-1-0.5-1-1V10h35v33C37,43.6,36.6,44,36,44z"></path>
  <g>
	  <path fill="#425563" d="M26.7,35.6h-0.6v1.9h0.6c0.6,0,1.4-0.2,1.4-0.9C28.1,35.7,27.4,35.6,26.7,35.6z"></path>
	  <path fill="#425563" d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.4,30.7,29,29,29z M16.9,38.5h-1.7 L14,33.2h0l-1.2,5.3h-1.7l-1.8-6.6h1.4l1.2,5.3h0l1.1-5.3h1.8l1.2,5.3h0l1.2-5.3h1.3L16.9,38.5z M23.4,38.5h-3.9v-6.6h3.9v1h-2.6 v1.6h2.4v1h-2.4v1.9h2.6V38.5z M27.1,38.5h-2.3v-6.6h2.3c0.9,0,2.1,0.2,2.1,1.7c0,0.8-0.5,1.3-1.3,1.5v0c0.9,0.1,1.5,0.7,1.5,1.5 C29.4,38.3,27.9,38.5,27.1,38.5z"></path>
	  <path fill="#425563" d="M27.9,33.8c0-0.8-0.7-0.8-1.3-0.8h-0.5v1.6h0.5C27.2,34.6,27.9,34.4,27.9,33.8z"></path>
  </g>
  <g fill="#768692">
    <rect x="24" y="14" width="7" height="2"></rect>
    <rect x="8" y="14" width="14" height="12"></rect>
    <rect x="24" y="17" width="7" height="2"></rect>
    <rect x="24" y="20" width="7" height="2"></rect>
  </g>
  <g>
    <rect x="4" y="4" width="2" height="2" fill="#009639"></rect>
    <rect x="7" y="4" width="2" height="2" fill="#FAE100"></rect>
    <rect x="10" y="4" width="2" height="2" fill="#B30F0F"></rect>
  </g></svg>

    
</span>

     <#elseif icontype == "page" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><path fill="#FFFFFF" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z"></path>
  <path fill="#425563" d="M36,0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V3C39,1.4,37.7,0,36,0z M3,2h33c0.5,0,1,0.5,1,1 v5H2V3C2,2.5,2.5,2,3,2z M36,44H3c-0.5,0-1-0.5-1-1V10h35v33C37,43.6,36.6,44,36,44z"></path>
  <g fill="#425563">
	  <path d="M6.3,23.1h2c1.6,0,2.9,0.5,2.9,2.3c0,1.7-1.3,2.3-2.7,2.3H7.4v3.1H6.3V23.1z M7.4,26.8h1.1
		c0.7,0,1.5-0.3,1.5-1.4c0-1-1-1.3-1.7-1.3H7.4V26.8z"></path>
	  <path d="M14.9,23.1h1.2l3.2,7.7h-1.2l-0.8-1.9h-3.8l-0.8,1.9h-1.2L14.9,23.1z M15.5,24.2L13.9,28H17L15.5,24.2z"></path>
	  <path d="M26.3,24.5c-0.5-0.4-1.1-0.5-2.1-0.5c-1.8,0-2.9,1.3-2.9,3c0,1.8,1.3,3,2.9,3c0.8,0,1-0.1,1.2-0.1v-2.3h-1.6
		v-0.9h2.7v4c-0.4,0.1-1.1,0.3-2.3,0.3c-2.4,0-4-1.6-4-4c0-2.4,1.7-3.9,4.1-3.9c1.1,0,1.6,0.2,2.3,0.4L26.3,24.5z"></path>
	  <path d="M28.4,23.1h4.3v1h-3.2v2.2h2.9v1h-2.9v2.5h3.2v1h-4.3V23.1z"></path>
  </g>
  <g>
    <rect x="4" y="4" width="2" height="2" fill="#009639"></rect>
    <rect x="7" y="4" width="2" height="2" fill="#FAE100"></rect>
    <rect x="10" y="4" width="2" height="2" fill="#B30F0F"></rect>
  </g></svg>

    
</span>

     <#elseif icontype == "pdf" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#B30F0F">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <path fill="#FFFFFF" d="M10,29h19c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3H10c-1.7,0-3-1.3-3-3v-6C7,30.4,8.4,29,10,29z"></path>
  <path fill="#B30F0F" d="M26.2,39v-3.4h2.6v-1.2h-2.6v-1.9H29v-1.2h-4.3V39H26.2z M19.2,37.8h-0.9v-5.3h0.9c1.3,0,2.5,1,2.5,2.6 S20.4,37.8,19.2,37.8z M18.9,39c2.4,0,4.4-0.8,4.4-3.8s-2.1-3.8-4.4-3.8h-2.1V39H18.9z M12.6,34.9h-0.5v-2.3h0.5 c0.8,0,1.5,0.3,1.5,1.2S13.4,34.9,12.6,34.9z M12.1,39v-2.9h0.6c1.7,0,3-0.6,3-2.4c0-1.8-1.5-2.3-3.2-2.3h-1.9V39H12.1z"></path>
  <path fill="#FFFFFF" d="M11.9,25c-0.4,0-0.8-0.1-1.1-0.4c-0.9-0.7-1-1.9-0.4-2.8c0.6-0.8,2-2,5-3.2c1.2-2.5,2.1-4.9,2.1-4.9l0-0.1 c0,0,0.1-0.2,0.2-0.5c-0.2-0.3-0.3-0.7-0.5-1C16.9,11,16,8.4,16.9,6.9c0.3-0.5,0.8-0.8,1.4-0.9c0.5,0,1,0.1,1.4,0.5 c0.7,0.7,0.9,2,0.7,3.6c-0.2,1.1-0.5,2.1-0.8,2.9c0.8,1.5,1.9,2.7,2.9,3.7c2.1-0.3,4.4-0.4,5.6,0.4c0.6,0.4,0.9,0.9,0.9,1.5 c0.1,0.7-0.2,1.3-0.8,1.7c-0.9,0.6-2.4,0.6-3.7-0.1c-0.5-0.3-1.5-0.9-2.6-1.8c-0.9,0.2-1.9,0.4-3,0.7c-0.9,0.3-1.6,0.5-2.3,0.7 c-0.6,1.2-1.4,2.5-2.1,3.4C13.6,24.6,12.7,25,11.9,25 M14.1,21.1c-1.4,0.8-2.1,1.4-2.3,1.7c-0.1,0.2-0.1,0.4,0,0.5 c0.1,0.1,0.6,0,1.4-0.9C13.5,22,13.8,21.6,14.1,21.1 M24.2,18.2c0.4,0.3,0.8,0.5,1,0.6c0.9,0.4,1.7,0.4,2,0.2c0.1,0,0.1-0.1,0.1-0.2 c0-0.1,0-0.2-0.2-0.3C26.7,18.2,25.7,18.1,24.2,18.2 M18.8,15c-0.2,0.7-0.7,1.7-1.2,2.9c0.3-0.1,0.5-0.2,0.8-0.2 c0.5-0.2,1.3-0.4,2.1-0.5C19.9,16.5,19.3,15.8,18.8,15 M18.4,7.7c0,0-0.1,0-0.1,0.1c-0.2,0.4-0.2,1.4,0.2,2.8 c0.1-0.2,0.1-0.5,0.1-0.7C18.9,8.5,18.6,7.8,18.4,7.7"></path></svg>

    
</span>

     <#elseif icontype == "doc" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><polygon fill="#0050A5" points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
	<path fill="#0050A5" d="M28,11V0H3C1.4,0,0,1.4,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  <path fill="#FFFFFF" d="M8.5,29h22c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3h-22c-1.7,0-3-1.3-3-3v-6C5.5,30.4,6.9,29,8.5,29z"></path>
  <path fill="#0050A5" d="M29.1,39.2c0.6,0,1.2-0.1,1.7-0.2l-0.1-1.3c-0.4,0.2-1.1,0.3-1.7,0.3c-1.6,0-2.6-1.2-2.6-2.7 c0-1.6,1-2.8,2.6-2.8c0.5,0,1.1,0.1,1.7,0.4l0.1-1.3c-0.6-0.2-1.2-0.3-1.7-0.3c-2.6,0-4.2,1.5-4.2,4.1 C24.9,37.9,26.6,39.2,29.1,39.2z M20.1,38c-1.6,0-2.2-1.4-2.2-2.8c0-1.4,0.6-2.7,2.2-2.7c1.5,0,2.2,1.4,2.2,2.7 C22.3,36.6,21.7,38,20.1,38z M20.1,39.2c2.4,0,3.8-1.7,3.8-4s-1.4-3.9-3.8-3.9c-2.4,0-3.8,1.6-3.8,3.9S17.7,39.2,20.1,39.2z M11.2,37.8h-0.9v-5.3h0.9c1.3,0,2.5,1,2.5,2.6S12.5,37.8,11.2,37.8z M10.9,39c2.4,0,4.4-0.8,4.4-3.8s-2.1-3.8-4.4-3.8H8.8V39H10.9z
	"></path>
  <g fill="#FFFFFF">
    <rect x="8" y="9" class="st3" width="15" height="2"></rect>
    <rect x="8" y="13" class="st3" width="15" height="2"></rect>
    <rect x="8" y="17" class="st3" width="22" height="2"></rect>
    <rect x="8" y="21" class="st3" width="22" height="2"></rect>
  </g></svg>

    
</span>

     <#elseif icontype == "txt" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g>
    <polygon fill="#425563" points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path fill="#425563" d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <path fill="#FFFFFF" d="M8.5,29h22c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3h-22c-1.7,0-3-1.3-3-3v-6C5.5,30.3,6.8,29,8.5,29z"></path>
  <path fill="#425563" d="M27,39v-6.5h2.2v-1.2h-5.9v1.2h2.2V39H27z M17.7,39l1.8-3l1.8,3h1.8l-2.5-4l2.3-3.7h-1.7l-1.6,2.7L18,31.3h-1.8 l2.3,3.7L16,39H17.7z M13.6,39v-6.5h2.2v-1.2H9.8v1.2H12V39H13.6z"></path>
  <g fill="#FFFFFF">
    <rect x="8" y="9" width="15" height="2"></rect>
    <rect x="8" y="13" width="15" height="2"></rect>
    <rect x="8" y="17" width="22" height="2"></rect>
    <rect x="8" y="21" width="22" height="2"></rect>
  </g></svg>

    
</span>

     <#elseif icontype == "xls" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><polygon points="30,9 39,9 39,9 30.1,0 30,0" fill="#006646"></polygon>
  <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z" fill="#006646"></path>
  <path d="M8,13v5h0v2h0v5h23V13H8z M29,18h-5v-3h5V18z M17,18v-3h5v3H17z M22,20v3h-5v-3H22z M10,15h5v3h-5V15z M10,20h5 v3h-5V20z M24,23v-3h5v3H24z" fill="#FFFFFF"></path>
  <path d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.3,30.7,29,29,29z M15.5,39l-1.8-3 l-1.8,3h-1.7l2.5-4l-2.3-3.7h1.8l1.6,2.7l1.6-2.7h1.6L14.8,35l2.5,4H15.5z M22.8,39h-4.5v-7.7h1.5v6.5h3V39z M25.6,39.1 c-0.8,0-1.2-0.1-2-0.3l0.1-1.4c0.5,0.3,1.1,0.5,1.7,0.5c0.6,0,1.4-0.3,1.4-1c0-1.5-3.4-0.9-3.4-3.4c0-1.7,1.3-2.3,2.7-2.3 c0.7,0,1.3,0.1,1.8,0.3l-0.1,1.3c-0.5-0.2-1-0.3-1.6-0.3c-0.5,0-1.2,0.2-1.2,1.1c0,1.3,3.4,0.8,3.4,3.3 C28.5,38.5,27.2,39.1,25.6,39.1z" fill="#FFFFFF"></path></svg>

    
</span>

     <#elseif icontype == "csv" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><polygon points="30,9 39,9 39,9 30.1,0 30,0" fill="#006646"></polygon>
  <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z" fill="#006646"></path>
  <path d="M8,13v5h0v2h0v5h23V13H8z M29,18h-5v-3h5V18z M17,18v-3h5v3H17z M22,20v3h-5v-3H22z M10,15h5v3h-5V15z M10,20h5 v3h-5V20z M24,23v-3h5v3H24z" fill="#FFFFFF"></path>
  <path d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.3,30.7,29,29,29z M14.2,39.1	c-2.5,0-4.2-1.2-4.2-3.8c0-2.6,1.6-4.1,4.2-4.1c0.5,0,1.2,0.1,1.7,0.3l-0.1,1.3c-0.6-0.3-1.1-0.4-1.7-0.4c-1.6,0-2.6,1.2-2.6,2.8 c0,1.6,1,2.7,2.6,2.7c0.6,0,1.3-0.1,1.7-0.3l0.1,1.3C15.4,39,14.8,39.1,14.2,39.1z M18.9,39.1c-0.8,0-1.2-0.1-2-0.3l0.1-1.4 c0.5,0.3,1.1,0.5,1.7,0.5c0.6,0,1.4-0.3,1.4-1c0-1.5-3.4-0.9-3.4-3.4c0-1.7,1.3-2.3,2.7-2.3c0.7,0,1.3,0.1,1.8,0.3l-0.1,1.3 c-0.5-0.2-1-0.3-1.6-0.3c-0.5,0-1.2,0.2-1.2,1.1c0,1.3,3.4,0.8,3.4,3.3C21.8,38.5,20.4,39.1,18.9,39.1z M26.9,39H25l-2.6-7.7H24l2,6 h0l1.9-6h1.5L26.9,39z" fill="#FFFFFF"></path></svg>

    
</span>

     <#elseif icontype == "img" || icontype?lower_case == "png" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#41B6E6">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11H28z"></path>
  </g>
  <g fill="#FFFFFF">
    <path class="st1" d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.3,30.7,29,29,29z M11.1,39H9.6v-7.7 h1.5V39z M21.4,39h-1.5v-6.3l0,0L17.8,39h-1.5l-2.1-6.3l0,0V39h-1.5v-7.7h2.5l1.8,5.8l0,0l1.8-5.8h2.5V39H21.4z M29.5,38.7 c-0.8,0.2-1.7,0.4-2.5,0.4c-2.5,0-4.2-1.2-4.2-3.8s1.6-4.1,4.2-4.1c0.9,0,1.6,0.1,2.3,0.3l-0.1,1.3c-0.6-0.3-1.4-0.4-2-0.4 c-1.8,0-2.8,1.2-2.8,2.8s1,2.7,2.6,2.7c0.4,0,0.7,0,1-0.1v-2h-1.6v-1.2h3.1V38.7z"></path>
    <path d="M30.6,25H8.5l6.6-8.7l3.3,4.3l5.1-9.6L30.6,25z M19.3,23h8l-3.9-7.7L19.3,23z M12.5,23h5.2l-2.6-3.4L12.5,23z"></path>
    <circle cx="13" cy="11" r="3"></circle>
  </g></svg>

    
</span>

     <#elseif icontype == "mov" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#AE2573">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M21,32.4c-1.5,0-2.2,1.4-2.2,2.7c0,1.4,0.6,2.8,2.2,2.8s2.2-1.4,2.2-2.8C23.2,33.8,22.6,32.4,21,32.4z"></path>
    <path d="M32,29H7c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h25c1.7,0,3-1.3,3-3v-6C35,30.3,33.7,29,32,29z M15.9,39h-1.5 v-6.3h0L12.3,39h-1.5l-2.1-6.3l0,0V39H7.3v-7.7h2.5l1.8,5.8h0l1.8-5.8h2.5V39z M21,39.1c-2.5,0-3.8-1.6-3.8-4s1.3-3.9,3.8-3.9 c2.4,0,3.8,1.6,3.8,3.9C24.8,37.5,23.5,39.1,21,39.1z M30,39h-1.9l-2.6-7.7h1.7l2,6h0l1.9-6h1.5L30,39z"></path>
    <path d="M19.5,10c-4.1,0-7.5,3.4-7.5,7.5s3.4,7.5,7.5,7.5c4.1,0,7.5-3.4,7.5-7.5S23.6,10,19.5,10z M18,21.2v-6.9l5,3.5 L18,21.2z"></path>
  </g></svg>

    
</span>

     <#elseif icontype == "ppt" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#FA9200">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M19.5,25c4.1,0,7.5-4,7.5-7.5c0-0.1-7.5,0-7.5,0s0.1-7.5,0-7.5c-4.1,0-7.5,3.4-7.5,7.5S15.4,25,19.5,25z"></path>
    <path d="M28,16c0-3.9-3.1-7-7-7c-0.1,0,0,7,0,7H28z"></path>
    <path d="M13.2,32.5h-0.5v2.3h0.5c0.8,0,1.5-0.3,1.5-1.1S14,32.5,13.2,32.5z"></path>
    <path d="M19.3,32.5h-0.5v2.3h0.5c0.8,0,1.5-0.3,1.5-1.1S20.1,32.5,19.3,32.5z"></path>
    <path d="M29,29H10c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h19c1.7,0,3-1.3,3-3v-6C32,30.3,30.7,29,29,29z M13.3,36.1h-0.6 V39h-1.5v-7.7H13c1.7,0,3.2,0.5,3.2,2.3C16.2,35.4,14.9,36.1,13.3,36.1z M19.4,36.1h-0.6V39h-1.5v-7.7h1.9c1.7,0,3.2,0.5,3.2,2.3 C22.4,35.4,21,36.1,19.4,36.1z M28.6,32.5h-2.2V39h-1.5v-6.5h-2.2v-1.2h5.9V32.5z"></path>
  </g></svg>

    
</span>

     <#elseif icontype == "zip" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#768692">
    <polygon points="31,12 38.8,12 33.3,6.5 31,4.2"></polygon>
    <path d="M29,14V4h1.8L27,0H3C1.4,0,0,1.4,0,3v37c0,1.7,1.3,3,3,3h1c0,1.7,1.3,3,3,3h29c1.7,0,3-1.3,3-3V14H29z M7,4
      C5.4,4,4,5.4,4,7v34H3c-0.6,0-1-0.5-1-1L2,3c0-0.5,0.5-1,1-1l23.1,0l1.9,2H7z"></path>
  </g>
  <g fill="#FFFFFF">
    <rect x="16" y="14" width="6" height="2"></rect>
    <rect x="16" y="20" width="6" height="2"></rect>
    <rect x="20" y="17" width="6" height="2"></rect>
    <rect x="20" y="11" width="6" height="2"></rect>
    <rect x="20" y="23" width="6" height="2"></rect>
    <path d="M26.9,32.6h-0.5v2.3h0.5c0.8,0,1.5-0.3,1.5-1.1S27.7,32.6,26.9,32.6z"></path>
    <path d="M31,29H13c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h18c1.7,0,3-1.3,3-3v-6C34,30.4,32.7,29,31,29z M20.6,39h-5.3 v-1.3l3.6-5.2h-3.5v-1.2h5.1v1.3l-3.6,5.2h3.7V39z M23.3,39h-1.5v-7.7h1.5V39z M27,36.1h-0.6V39h-1.5v-7.7h1.9 c1.7,0,3.2,0.5,3.2,2.3C30,35.5,28.7,36.1,27,36.1z"></path>
  </g></svg>

    
</span>

     <#elseif icontype == "jar" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#231F20">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M8,29h23c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3H8c-1.7,0-3-1.3-3-3v-6C5,30.3,6.4,29,8,29z"></path>
    <polygon points="14.8,14.8 11,18.5 14.8,22.2 16.2,20.8 13.8,18.5 16.2,16.2"></polygon>
    <polygon points="20,12 17.2,24.5 19.1,25 21.9,12.5"></polygon>
    <polygon points="22.9,16.2 25.2,18.5 22.9,20.8 24.3,22.2 28,18.5 24.3,14.8"></polygon>
  </g>
  <path d="M25.1,34.6h-0.5v-2.1h0.5c0.8,0,1.6,0.1,1.6,1C26.7,34.5,25.8,34.6,25.1,34.6z M24.6,39v-3.2h0.5 c0.6,0,0.8,0.2,1.1,0.8l0.9,2.4h1.7l-1.2-3c-0.2-0.3-0.4-0.8-0.8-0.8v0c1-0.1,1.6-0.9,1.6-1.8c0-1.9-1.5-2.1-3-2.1l-0.3,0l-2,0V39 H24.6z M19.4,36h-2.2l1.1-3.2h0L19.4,36z M16,39l0.7-1.8h3.1l0.7,1.8h1.7l-3-7.7h-1.7l-3,7.7H16z M11.5,39.1c1.6,0,2.1-1.1,2.1-2 v-5.9H12v5.1c0,0.5,0,1.4-1,1.4c-0.3,0-0.5-0.1-0.7-0.1V39C10.7,39.1,11.1,39.1,11.5,39.1z" fill="#231F20"></path></svg>

    
</span>

     <#elseif icontype == "json" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#231F20">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M7,29h25c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3H7c-1.7,0-3-1.3-3-3v-6C4,30.3,5.4,29,7,29z"></path>
    <polygon points="14.8,14.8 11,18.5 14.8,22.2 16.2,20.8 13.8,18.5 16.2,16.2"></polygon>
    <polygon points="20,12 17.2,24.5 19.1,25 21.9,12.5"></polygon>
    <polygon points="22.9,16.2 25.2,18.5 22.9,20.8 24.3,22.2 28,18.5 24.3,14.8"></polygon>
  </g>
  <path d="M27.3,39v-5.7h0l2.9,5.7h1.9v-7.7h-1.5v5.7h0l-2.9-5.7h-1.9V39H27.3z M20.8,37.9c-1.6,0-2.2-1.4-2.2-2.8 c0-1.4,0.6-2.7,2.2-2.7c1.5,0,2.2,1.4,2.2,2.7C22.9,36.5,22.3,37.9,20.8,37.9z M20.8,39.1c2.4,0,3.8-1.7,3.8-4 c0-2.3-1.4-3.9-3.8-3.9c-2.4,0-3.8,1.6-3.8,3.9S18.3,39.1,20.8,39.1z M13.1,39.1c1.6,0,2.9-0.6,2.9-2.3c0-2.6-3.4-2-3.4-3.3 c0-0.8,0.7-1.1,1.2-1.1c0.5,0,1.1,0.1,1.6,0.3l0.1-1.3c-0.6-0.2-1.2-0.3-1.8-0.3c-1.4,0-2.7,0.6-2.7,2.3c0,2.5,3.4,1.9,3.4,3.4 c0,0.7-0.8,1-1.4,1c-0.6,0-1.2-0.2-1.7-0.5l-0.1,1.4C11.9,39,12.3,39.1,13.1,39.1z M7.5,39.1c1.6,0,2.1-1.1,2.1-2v-5.9H8.1v5.1 c0,0.5,0,1.4-1,1.4c-0.3,0-0.5-0.1-0.7-0.1V39C6.8,39.1,7.1,39.1,7.5,39.1z" fill="#231F20"></path></svg>

    
</span>

     <#elseif icontype == "xml" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#231F20">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M31,29H8c-1.7,0-3,1.3-3,3v6c0,1.7,1.3,3,3,3h23c1.7,0,3-1.3,3-3v-6C34,30.3,32.7,29,31,29z M13.3,39l-1.8-3 l-1.8,3H8l2.5-4l-2.3-3.7H10l1.6,2.7l1.6-2.7h1.7L12.6,35l2.5,4H13.3z M24.7,39h-1.5v-6.3h0L21.2,39h-1.5l-2.1-6.3l0,0V39h-1.5v-7.7 h2.5l1.8,5.8h0l1.8-5.8h2.5V39z M31.1,39h-4.5v-7.7h1.5v6.5h3V39z"></path>
    <polygon points="14.8,14.8 11,18.5 14.8,22.2 16.2,20.8 13.8,18.5 16.2,16.2"></polygon>
    <polygon points="20,12 17.2,24.5 19.1,25 21.9,12.5"></polygon>
    <polygon points="22.9,16.2 25.2,18.5 22.9,20.8 24.3,22.2 28,18.5 24.3,14.8"></polygon>
  </g></svg>

</span>

     <#elseif icontype == "war" >

  <span class="nhsd-a-document-icon ${sizeClass}">
    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 39 46"><g fill="#231F20">
    <polygon points="30,9 39,9 39,9 30.1,0 30,0"></polygon>
    <path d="M28,11V0H3C1.4,0,0,1.3,0,3v40c0,1.7,1.3,3,3,3h33c1.7,0,3-1.3,3-3V11L28,11z"></path>
  </g>
  <g fill="#FFFFFF">
    <path d="M8,29h23c1.7,0,3,1.3,3,3v6c0,1.7-1.3,3-3,3H8c-1.7,0-3-1.3-3-3v-6C5,30.3,6.4,29,8,29z"></path>
    <polygon points="14.8,14.8 11,18.5 14.8,22.2 16.2,20.8 13.8,18.5 16.2,16.2"></polygon>
    <polygon points="20,12 17.2,24.5 19.1,25 21.9,12.5"></polygon>
    <polygon points="22.9,16.2 25.2,18.5 22.9,20.8 24.3,22.2 28,18.5 24.3,14.8"></polygon>
  </g>
  <path d="M28.2,34.6h-0.5v-2.1h0.5c0.8,0,1.6,0.1,1.6,1C29.9,34.5,29,34.6,28.2,34.6z M27.7,39v-3.2h0.5
	c0.6,0,0.8,0.2,1.1,0.8l0.9,2.4h1.7l-1.2-3c-0.2-0.3-0.4-0.8-0.8-0.8v0c1-0.1,1.6-0.9,1.6-1.8c0-1.9-1.5-2.1-3-2.1l-0.3,0l-2,0V39 H27.7z M22.5,36h-2.2l1.1-3.2h0L22.5,36z M19.2,39l0.7-1.8H23l0.7,1.8h1.7l-3-7.7h-1.7l-3,7.7H19.2z M11,39l1.4-6.1h0l1.4,6.1h2 l2-7.7h-1.5l-1.4,6.1h0l-1.4-6.1h-2.1l-1.3,6.1h0l-1.4-6.1H7L9,39H11z" fill="#231F20"></path></svg>

    
</span>

    </#if>
</#macro>
