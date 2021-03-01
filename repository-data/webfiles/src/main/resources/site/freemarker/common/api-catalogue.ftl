<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "macro/metaTags.ftl">
<#include "macro/contentPixel.ftl">

<#-- Add meta tags -->
<@metaTags></@metaTags>
<#-- Content Page Pixel -->
<@contentPixel document.getCanonicalUUID() document.title></@contentPixel>
<#if document.anchor>
<#include "list-article/ordered-list-article.ftl">
<#else>
<#include "list-article/unordered-list-article.ftl">
</#if>
