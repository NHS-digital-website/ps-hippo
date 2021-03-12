<#ftl output_format="HTML">

<#macro personitem author>
    <#if author?? && author?has_content >
        <div class="blog-authors__item">

            <div class="blog-authors__icon">
                <#if author.personimages?? && author.personimages?has_content && author.personimages.picture?has_content>
                    <@hst.link hippobean=author.personimages.picture.authorPhotoLarge fullyQualified=true var="authorPicture" />
                    <@hst.link hippobean=author.personimages.picture.authorPhotoLarge2x fullyQualified=true var="authorPicture2x" />
                    <img class="blog-authors__icon__img"
                         srcset="${authorPicture} 200px, ${authorPicture2x} 400px"
                         sizes="200px"
                         src="${authorPicture}" alt="${author.title}"/>
                <#else>
                    <img class="blog-authors__icon__img" src="<@hst.webfile path="/images/fibre_57101102_med.jpg"/>" alt="NHS Digital blog">
                </#if>
            </div>

            <div class="blog-authors__content">
                <div class="blog-authors__title">
                    <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, author.title) />
                    <a class="cta__title cta__button" href="<@hst.link hippobean=author/>"  onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${author.title}</a>
                </div>
                <div class="blog-authors__body">
                    <#if author.biographies?? && author.biographies?has_content && author.biographies.profbiography.content?has_content>
                        <@hst.html hippohtml=author.biographies.profbiography contentRewriter=gaContentRewriter/>
                    </#if>
                </div>
            </div>

        </div>
    </#if>
</#macro>
