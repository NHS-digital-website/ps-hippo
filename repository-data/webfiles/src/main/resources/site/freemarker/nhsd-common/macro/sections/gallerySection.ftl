<#ftl output_format="HTML">

<#include "../fileIconByMimeType.ftl">

<#macro gallerySection section mainHeadingLevel=2 >
    <div id="${slugify(section.heading)}" class="${(section.headingLevel?has_content && section.headingLevel == 'Main heading')?then('article-section navigationMarker', 'article-header__detail-lines')}">

        <#if section.headingLevel?has_content && section.headingLevel == 'Main heading'>
            <#assign mainHeadingTag = "h" + mainHeadingLevel />
            <${mainHeadingTag} data-uipath="website.contentblock.gallerysection.title">${section.title}</${mainHeadingTag}>
        <#else>
            <#assign subHeadingLevel = mainHeadingLevel?int + 1 />
            <#assign subHeadingTag = "h" + subHeadingLevel />
            <${subHeadingTag} data-uipath="website.contentblock.gallerysection.title">${section.title}</${subHeadingTag}>
        </#if>

        <div data-uipath="website.contentblock.gallerysection.description">
            <@hst.html hippohtml=section.description contentRewriter=gaContentRewriter />
        </div>

        <div class="grid-row galleryItems">
            <#assign itemNr = 0 />
            <#assign hasPrevEvenItemTitle = false />
            <#list section.galleryItems as galleryItem>
                <#assign itemNr = itemNr + 1 />

                <#if itemNr % 2 == 1>
                  <#if galleryItem.title?has_content>
                    <#assign hasPrevEvenItemTitle = true />
                  <#else>
                    <#assign hasPrevEvenItemTitle = false />
                  </#if>
                </#if>

                <div class="column column--one-half galleryItems__item">
                    <#if galleryItem.title?has_content>
                      <h3 class="galleryItems__heading">${galleryItem.title}</h3>
                      <div class="galleryItems__card">
                    <#else>
                      <#if itemNr % 2 == 0 && hasPrevEvenItemTitle>
                        <div class="galleryItems__card-no-heading-left">
                      <#else>
                        <div class="galleryItems__card">
                      </#if>
                    </#if>
                        <#if galleryItem.imageWarning != ''>
                            <div class="galleryItems__warning">${galleryItem.imageWarning}</div>
                        </#if>

                        <@hst.link hippobean=galleryItem.image.original fullyQualified=true var="image" />

                        <img src="${image}" alt="${galleryItem.imageAlt}" />

                        <#if galleryItem.description.content?has_content>
                          <div class="galleryItems__description">
                              <@hst.html hippohtml=galleryItem.description contentRewriter=gaContentRewriter />
                          </div>
                        </#if>

                    </div>

                    <ol class="list list--reset">
                        <#list galleryItem.relatedFiles as attachment>

                            <@hst.link hippobean=attachment.link var="link" />
                            <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, link) />

                            <li class="attachment" itemprop="hasPart" itemscope itemtype="http://schema.org/MediaObject">
                                <a href="<@hst.link hippobean=attachment.link />" class="block-link" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">
                                    <div class="block-link__header">
                                        <#if attachment.link.asset?has_content>
                                          <@fileIconByMimeType attachment.link.asset.mimeType></@fileIconByMimeType>
                                        <#else>
                                          <@fileIconByMimeType attachment.link.original.mimeType></@fileIconByMimeType>
                                        </#if>
                                    </div>
                                    <div class="block-link__body">
                                        <span class="block-link__title">${attachment.title}</span>
                                        <#if attachment.link.asset?has_content>
                                          <@fileMetaAppendix attachment.link.asset.getLength(), attachment.link.asset.mimeType></@fileMetaAppendix>
                                        <#else>
                                          <@fileMetaAppendix attachment.link.original.getLength(), attachment.link.original.mimeType></@fileMetaAppendix>
                                        </#if>
                                    </div>
                                </a>
                            </li>
                        </#list>
                    </ol>

                </div>
                <#if galleryItem?is_even_item>
                    <div class="clearfix"></div>
                </#if>
            </#list>
        </div>
    </div>
</#macro>
