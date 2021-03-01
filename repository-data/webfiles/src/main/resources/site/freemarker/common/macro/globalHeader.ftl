<#ftl output_format="HTML">
<#include "./nhsdLogo.ftl">
<#include "./iconGenerator.ftl">

<@hst.setBundle basename="rb.generic.texts"/>
<@fmt.message key="text.close-menu" var="closeMenu" />
<@fmt.message key="text.close-search" var="closeSearch" />

<#macro globalHeader enableHr>
    <header id="header">
        <div class="nhsd-o-global-header" id="nhsd-global-header">
            <div class="nhsd-t-grid">
                <div class="nhsd-t-row">
                    <div class="nhsd-t-col">
                        <div class="nhsd-o-global-header__content-box">
                            <div class="nhsd-o-global-header__background"></div>
                            <#-- Logo -->
                            <a class="nhsd-m-logo-link nhsd-o-global-header__logo" id="nhsd-global-header__logo" href="<@hst.link siteMapItemRefId='root'/>" aria-label="NHS Digital home">
                                <@nhsdLogo></@nhsdLogo>
                            </a>
                            <div class="nhsd-o-global-header__menu" id="nhsd-global-header__menu">
                                <div class="nhsd-o-global-header__menu-background"></div>
                                <div class="nhsd-o-global-header__menu-content-box">
                                    <a class="nhsd-a-icon-link nhsd-o-global-header__menu-close-button" id="nhsd-global-header__menu-close-button" href="#">
                                        <span class="nhsd-a-icon-link__label">${closeMenu}</span>
                                        <span class="nhsd-a-icon nhsd-a-icon--size-m">
                                            <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="100%" height="100%">
                                                <path d="M8.9,8l3.1,3.1L11.1,12L8,8.9L4.9,12L4,11.1L7.1,8L4,4.9L4.9,4L8,7.1L11.1,4L12,4.9L8.9,8z"></path>
                                                <path d="M8,1.3c3.7,0,6.7,3,6.7,6.7s-3,6.7-6.7,6.7s-6.7-3-6.7-6.7S4.3,1.3,8,1.3 M8,0C3.6,0,0,3.6,0,8s3.6,8,8,8 s8-3.6,8-8S12.4,0,8,0L8,0z"></path>
                                            </svg>
                                        </span>
                                    </a>
                                    <#-- Navigation -->
                                    <@hst.include ref="main-nav"/>
                                </div>
                            </div>
                            <nav class="nhsd-m-button-nav nhsd-m-button-nav--condensed nhsd-m-button-nav--non-responsive nhsd-o-global-header__button-nav">
                                <a class="nhsd-a-button nhsd-a-button--circle" id="nhsd-global-header__search-button" aria-label="Open search" aria-controls="nhsd-global-header__search" aria-expanded="false" href="${searchLink}">
                                    <@buildInlineSvg "search" "s"/>
                                </a>
                                <button class="nhsd-a-button nhsd-o-global-header__menu-button" id="nhsd-global-header__menu-button" type="button" aria-controls="nhsd-global-header__menu" aria-expanded="false">
                                    <span class="nhsd-a-button__label">Menu</span>
                                    <span class="nhsd-a-icon nhsd-a-icon--size-s">
                                        <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="100%" height="100%">
                                            <rect x="1" y="3.1" class="st0" width="14" height="1.6"></rect>
                                            <rect x="1" y="7.2" class="st0" width="14" height="1.6"></rect>
                                            <rect x="1" y="11.3" class="st0" width="14" height="1.6"></rect>
                                        </svg>
                                    </span>
                                </button>
                            </nav>
                            <div class="nhsd-o-global-header__search" id="nhsd-global-header__search">
                                <div class="nhsd-o-global-header__search-background"></div>
                                <div class="nhsd-o-global-header__search-content-box">
                                    <a class="nhsd-a-icon-link nhsd-o-global-header__search-close-button" id="nhsd-global-header__search-close-button" href="#">
                                        <span class="nhsd-a-icon-link__label">${closeSearch}</span>
                                        <span class="nhsd-a-icon nhsd-a-icon--size-m">
                                            <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="100%" height="100%">
                                                <path d="M8.9,8l3.1,3.1L11.1,12L8,8.9L4.9,12L4,11.1L7.1,8L4,4.9L4.9,4L8,7.1L11.1,4L12,4.9L8.9,8z"></path>
                                                <path d="M8,1.3c3.7,0,6.7,3,6.7,6.7s-3,6.7-6.7,6.7s-6.7-3-6.7-6.7S4.3,1.3,8,1.3 M8,0C3.6,0,0,3.6,0,8s3.6,8,8,8 s8-3.6,8-8S12.4,0,8,0L8,0z"></path>
                                            </svg>
                                        </span>
                                    </a>
                                    <div class="nhsd-m-search-bar">
                                        <form role="search" method="get" action="${searchLink}" class="nhsd-t-form" novalidate="" autocomplete="off" aria-label="Search">
                                            <div class="nhsd-t-form-group">
                                                <div class="nhsd-t-form-control">
                                                    <input class="nhsd-t-form-input" type="text" id="query" name="query" autocomplete="off" placeholder="What are you looking for today?" aria-label="Keywords">
                                                    <span class="nhsd-t-form-control__button">
													<button class="nhsd-a-button nhsd-a-button--circle-condensed nhsd-a-button--transparent" type="submit" aria-label="Perform search">
														<@buildInlineSvg "search" "s"/>
													</button>
												</span>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <#if enableHr>
                <hr class="nhsd-a-horizontal-rule nhsd-!t-margin-0">
            </#if>
        </div>
    </header>
</#macro>
