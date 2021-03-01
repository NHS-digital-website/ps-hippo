<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<@hst.setBundle basename="homepage.website.labels"/>

<#if pageable?? && pageable.items?has_content>
    <div class="homeland-blog">
        <div class="article-section__header">
            <h2>Latest Blogs</h2>
        </div>

        <div class="grid-row">

            <div class="column column--reset">
                <#list pageable.items as item>

                    <div class="homeland-blog__item filter-list__item" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting">
                        <div class="homeland-blog__item__icon" itemprop="image" itemscope itemtype="http://schema.org/ImageObject">
                            <#if item.leadImage??>
                                <@hst.link hippobean=item.leadImage.homeBlogThumb fullyQualified=true var="leadImage" />
                                <@hst.link hippobean=item.leadImage.homeBlogThumb2x fullyQualified=true var="leadImage2x" />
                                <@hst.link hippobean=item.leadImage.homeBlogThumbSmall fullyQualified=true var="leadImageSmall" />
                                <@hst.link hippobean=item.leadImage.homeBlogThumbSmall2x fullyQualified=true var="leadImageSmall2x" />
                                <meta itemprop="url" content="${leadImage}">
                                <img itemprop="contentUrl" class="homeland-blog__icon__img"
                                     srcset="
                                        ${leadImageSmall} 341w,
                                        ${leadImageSmall2x} 682w,
                                        ${leadImage} 468w,
                                        ${leadImage2x} 936w
                                      "
                                     sizes="(min-width: 1000px) 468px, (min-width: 642px) 46vw, calc(100vw - 34px)"
                                     src="${leadImage}" alt="${item.title}" />
                            <#else>
                                <meta itemprop="url" content="<@hst.webfile path="/images/fibre_57101102_med.jpg"/>" />
                                <img itemprop="contentUrl" src="<@hst.webfile path="/images/fibre_57101102_med.jpg"/>" alt="Default Blog Hub Image" class="latestBlog__icon__img">
                            </#if>
                        </div>

                        <div class="homeland-blog__item__content">
                            <div itemprop="headline" class="homeland-blog__item__content__title"><a class="cta__title cta__button" href="<@hst.link hippobean=item/>">${item.title}</a>
                            </div>

                            <div class="homeland-blog__item__content__date" itemprop="datePublished">
                                <@fmt.formatDate value=item.dateOfPublication.time type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
    </div>
</#if>
