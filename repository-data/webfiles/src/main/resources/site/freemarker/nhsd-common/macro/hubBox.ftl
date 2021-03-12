<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro hubBox options metadata={} hiddenSchemaList=[]>
    <#if options??>
        <#assign hasMetaData = metadata?? && metadata?has_content/>
        <#assign itemscope = hasMetaData?then(metadata.itemscope,"") />
        <#assign itemName = hasMetaData?then(metadata.name,"") />
        <#assign itemDatePublished = hasMetaData?then(metadata.datePublished,"") />

        <article class="hub-box${(options.imagesection??)?then(' hub-box--with-icon', '')}" ${itemscope}>
            <#if hiddenSchemaList?? && hiddenSchemaList?has_content>
                <#list hiddenSchemaList as schema>
                    <#if schema.prop == 'keyword'>
                        <meta itemprop="keywords" content="${schema.value}"/>
                    <#else>
                        <span itemprop="${schema.prop}" class="is-hidden">${schema.value}</span>
                    </#if>
                </#list>
            </#if>

            <#if options.background??>
            <div class="hub-box__image" style="background-image: url('${options.background}');"></div>
            </#if>

            <#if (options.imagesection??) && options.imagesection.leadImage??>
                <div class="hub-box__icon">
                  <#if options.imagesection != "EMPTY">
                      <#assign alttext = options.imagesection.alttext?has_content?then(options.imagesection.alttext, "NHS Digital article ") />
                  </#if>

                  <#if options.imagesection == "EMPTY">
                      <img class="hub-box__icon-img" src="<@hst.webfile path='/images/fibre_57101102_med.jpg'/>" alt="NHS Digital article" >
                  <#elseif options.imagesection?has_content && options.imagesection.leadImage?has_content>
                      <#if options.largeImage>
                          <@hst.link hippobean=options.imagesection.leadImage.newsFeaturedPost fullyQualified=true var="leadImage" />
                          <@hst.link hippobean=options.imagesection.leadImage.newsFeaturedPost2x fullyQualified=true var="leadImage2x" />
                          <@hst.link hippobean=options.imagesection.leadImage.postImageSmall fullyQualified=true var="leadImageSmall" />
                          <@hst.link hippobean=options.imagesection.leadImage.postImageSmall2x fullyQualified=true var="leadImageSmall2x" />
                          <img class="hub-box__icon-img" srcset="
                                ${leadImageSmall} 343w,
                                ${leadImageSmall2x} 686w,
                                ${leadImage} 696w,
                                ${leadImage2x} 1392w
                            " sizes="(min-width: 925px) 696px, calc(100vw - 32px)" src="${leadImage}" alt="${alttext}" />
                      <#else>
                          <@hst.link hippobean=options.imagesection.leadImage.newsThumbnail fullyQualified=true var="leadImage" />
                          <@hst.link hippobean=options.imagesection.leadImage.newsThumbnail2x fullyQualified=true var="leadImage2x" />
                          <@hst.link hippobean=options.imagesection.leadImage.postImageSmall fullyQualified=true var="leadImageSmall" />
                          <@hst.link hippobean=options.imagesection.leadImage.postImageSmall2x fullyQualified=true var="leadImageSmall2x" />
                          <img class="hub-box__icon-img" srcset="
                                ${leadImageSmall} 343w,
                                ${leadImageSmall2x} 686w,
                                ${leadImage} 154w,
                                ${leadImage2x} 308w
                            " sizes="(min-width: 642px) 154px, calc(100vw - 32px)" src="${leadImage}" alt="${alttext}" />
                      </#if>
                  <#else>
                      <img class="hub-box__icon-img" src="<@hst.webfile path='/images/fibre_57101102_med.jpg'/>" alt="NHS Digital article" >
                  </#if>
                </div>
            </#if>

            <div class="hub-box__contents">
                <#if options.colorbox?has_content>
                  <div class="colour-class-${options.colorbox}">${options.colorbox?upper_case}</div>
                </#if>

                <#if options.title??>
                    <#--shema:name-->
                    <h2 class="hub-box__title" ${(!options.link??)?then(itemName,"")}>
                        <#if options.link??>
                        <a class="hub-box__title-a" href="${options.link}" ${itemName}>
                        </#if>
                        ${options.title}
                        <#if options.link??>
                        </a>
                        </#if>
                    </h2>
                </#if>

                <#if options.date??>
                <#--shema:datePublished-->
                <span class="hub-box__meta" ${itemDatePublished}>${options.date}</span>
                </#if>

                <#if options.text??>
                <p class="hub-box__text">${options.text}</p>
                </#if>

                <#if options.htmlText??>
                    <div class="hub-box__text">
                        <@hst.html hippohtml=options.htmlText contentRewriter=gaContentRewriter />
                    </div>
                </#if>

                <#if options.relatedLinks?has_content>
                    <div class="hub-box__links">
                        <span class="hub-box__links-title">Related to:</span>
                        <ul class="hub-box__links-list">
                            <#list options.relatedLinks as link>
                                <li>
                                    <a class="hub-box__links-anchor" href="${link.url}">${link.title}</a>
                                </li>
                            </#list>
                        </ul>
                    </div>
                </#if>

                <#if options.types??>
                <ul class="tag-list">
                <#list options.types as type>
                    <li class="tag">${type}</li>
                </#list>
                </ul>
                </#if>
            </div>
        </article>
    </#if>
</#macro>
