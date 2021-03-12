<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.PersonImage" -->

<#include "../../include/imports.ftl">

  <#macro personimage image idsuffix>
    <#if image?? && image?has_content && image.picture?has_content>
      <div id="personimage-${slugify(idsuffix)}" class="personimage--div galleryItems__item" itemscope itemtype="http://schema.org/ImageObject">
        <@hst.link var="picture" hippobean=image.picture.original fullyQualified=true />
        <div class="galleryItems__card">
          <img itemprop="contentUrl" src="${picture}" alt="Person image" />
          <div class="galleryItems__description">
            <p>
              ${imagedistributiontagging[image.imagedistributiontagging]}
            <p>
          </div>
        </div>
      </div>
    </#if>
  </#macro>
