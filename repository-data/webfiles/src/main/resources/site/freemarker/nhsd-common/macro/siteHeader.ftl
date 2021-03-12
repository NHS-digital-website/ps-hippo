<#ftl output_format="HTML">
<#macro siteHeader enableSearch>
<header class="site-header <#if enableSearch>site-header--with-search<#else>site-header--without-search</#if>" id="header">
    <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide">
        <div class="grid-row">
            <div class="column column--reset">
                <div class="grid-wrapper grid-wrapper--collapse">
                    <div class="grid-row">

                        <div class="column column--18-75 column--reset">
                            <a class="site-header-a__logo" href="<@hst.link siteMapItemRefId='root'/>"><img src="<@hst.webfile path="/images/nhs-digital-logo.svg"/>" alt="NHS Digital logo" class="site-header__logo"></a>
                        </div>

                        <#assign wrapperClassName = "site-header__search-wrapper site-header__search-wrapper--collapse" />
                        <#if enableSearch>
                        <#assign wrapperClassName = "site-header__search-wrapper" />
                        </#if>



                        <div class="main-nav">

                            <div class="${wrapperClassName}">
                                <#if enableSearch>
                                <#include "../../include/search-strip.ftl">
                                </#if>
                            </div>

                            <nav>
                                <button tabindex="0" class="main-nav__burger" aria-label="Navigation menu" id="navToggle">
                                    <span class="main-nav__burger-button">
                                        <span class="main-nav__burger-line-group">
                                            <span class="main-nav__burger-line">&nbsp;</span>
                                            <span class="main-nav__burger-line">&nbsp;</span>
                                            <span class="main-nav__burger-line">&nbsp;</span>
                                        </span>
                                    </span>
                                </button>
                                <div class="column <#if !enableSearch>column--81-25</#if> column--reset">
                                    <div class="main-nav__menu">
                                        <@hst.include ref="top-menu"/>
                                    </div>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
</#macro>
