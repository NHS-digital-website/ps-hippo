<#ftl output_format="HTML">
<#macro siteHeader enableSearch = true>
    <header class="nhsd-o-global-header site-header site-header--intranet" id="nhsd-global-header">
        <div class="nhsd-t-grid">
            <div class="nhsd-t-row">
                <div class="nhsd-t-col">
                    <div class="nhsd-o-global-header__content-box">
                        <div style="display:flex;align-items:center;">
                            <a class="site-header__waffle-link" style="all:inherit" href="https://www.office.com/" target="_blank" aria-label="Office 365"><span class="ms-Icon ms-Icon--WaffleOffice365"></span></a>
                            <a class="nhsd-m-logo-link site-header-a__logo nhsd-!t-margin-left-2" style="min-width:120px" href="<@hst.link siteMapItemRefId='root'/>"><img class="nhsd-!t-margin-0" src="<@hst.webfile path="/images/nhs-digital-intranet-logo.svg"/>" alt="NHS Digital Intranet logo" class="site-header__logo"></a>
                        </div>
                        <div class="nhsd-o-global-header__menu" id="nhsd-global-header__menu">
                            <div class="nhsd-o-global-header__menu-background"></div>
                            <div class="nhsd-o-global-header__menu-content-box">
                                <a class="nhsd-a-icon-link nhsd-o-global-header__menu-close-button"id="nhsd-global-header__menu-close-button" href="#">
                                    <span class="nhsd-a-icon-link__label">Close menu</span>
                                    <span class="nhsd-a-icon nhsd-a-icon--size-m">
                                        <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                            <path d="M8.9,8l3.1,3.1L11.1,12L8,8.9L4.9,12L4,11.1L7.1,8L4,4.9L4.9,4L8,7.1L11.1,4L12,4.9L8.9,8z"/>
                                            <path d="M8,1.3c3.7,0,6.7,3,6.7,6.7s-3,6.7-6.7,6.7s-6.7-3-6.7-6.7S4.3,1.3,8,1.3 M8,0C3.6,0,0,3.6,0,8s3.6,8,8,8 s8-3.6,8-8S12.4,0,8,0L8,0z"/>
                                        </svg>
                                    </span>
                                </a>
                                <@hst.include ref="top-menu"/>
                            </div>
                        </div>
                        <nav class="nhsd-m-button-nav nhsd-m-button-nav--condensed nhsd-m-button-nav--non-responsive nhsd-o-global-header__button-nav">
                            <a class="nhsd-a-button nhsd-a-button--circle"id="nhsd-global-header__search-button" aria-label="Open search"aria-controls="nhsd-global-header__search"aria-expanded="false" href="/search">
                                <span class="nhsd-a-icon nhsd-a-icon--size-s">
                                    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                        <path d="M7,10.9c-2.1,0-3.9-1.7-3.9-3.9c0-2.1,1.7-3.9,3.9-3.9c2.1,0,3.9,1.7,3.9,3.9C10.9,9.2,9.2,10.9,7,10.9zM13.4,14.8l1.4-1.4l-3-3c0.7-1,1.1-2.1,1.1-3.4c0-3.2-2.6-5.8-5.8-5.8C3.8,1.2,1.2,3.8,1.2,7c0,3.2,2.6,5.8,5.8,5.8c1.3,0,2.4-0.4,3.4-1.1L13.4,14.8z"/>
                                    </svg>
                                </span>
                            </a>
                            <button class="nhsd-a-button nhsd-o-global-header__menu-button"id="nhsd-global-header__menu-button" type="button" aria-controls="nhsd-global-header__menu"aria-expanded="false">
                                <span class="nhsd-a-button__label">Menu</span>
                                <span class="nhsd-a-icon nhsd-a-icon--size-s">
                                    <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                        <rect x="1" y="3.1" class="st0" width="14" height="1.6"/>
                                        <rect x="1" y="7.2" class="st0" width="14" height="1.6"/>
                                        <rect x="1" y="11.3" class="st0" width="14" height="1.6"/>
                                    </svg>
                                </span>
                            </button>
                        </nav>
                        <div class="nhsd-o-global-header__search" id="nhsd-global-header__search">
                            <div class="nhsd-o-global-header__search-background"></div>
                            <div class="nhsd-o-global-header__search-content-box">
                                <a class="nhsd-a-icon-link nhsd-o-global-header__search-close-button"id="nhsd-global-header__search-close-button" href="#">
                                    <span class="nhsd-a-icon-link__label">Close search</span>
                                    <span class="nhsd-a-icon nhsd-a-icon--size-m">
                                        <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                            <path d="M8.9,8l3.1,3.1L11.1,12L8,8.9L4.9,12L4,11.1L7.1,8L4,4.9L4.9,4L8,7.1L11.1,4L12,4.9L8.9,8z"/>
                                            <path d="M8,1.3c3.7,0,6.7,3,6.7,6.7s-3,6.7-6.7,6.7s-6.7-3-6.7-6.7S4.3,1.3,8,1.3 M8,0C3.6,0,0,3.6,0,8s3.6,8,8,8 s8-3.6,8-8S12.4,0,8,0L8,0z"/>
                                        </svg>
                                    </span>
                                </a>
                                <div class="nhsd-m-search-bar">
                                    <form role="search" method="get" action="${searchLink}" class="nhsd-t-form" novalidate autocomplete="off" aria-label="Search">
                                        <div class="nhsd-t-form-group">
                                            <div class="nhsd-t-form-control">
                                                <input class="nhsd-t-form-input" type="text" id="query" name="query" autocomplete="off" placeholder="What are you looking for today?" aria-label="Keywords" />
                                                <span class="nhsd-t-form-control__button">
                                                    <button class="nhsd-a-button nhsd-a-button--circle-condensed nhsd-a-button--transparent" type="submit" aria-label="Perform search">
                                                        <span class="nhsd-a-icon nhsd-a-icon--size-s">
                                                            <svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false" viewBox="0 0 16 16"  width="100%" height="100%">
                                                                <path d="M7,10.9c-2.1,0-3.9-1.7-3.9-3.9c0-2.1,1.7-3.9,3.9-3.9c2.1,0,3.9,1.7,3.9,3.9C10.9,9.2,9.2,10.9,7,10.9zM13.4,14.8l1.4-1.4l-3-3c0.7-1,1.1-2.1,1.1-3.4c0-3.2-2.6-5.8-5.8-5.8C3.8,1.2,1.2,3.8,1.2,7c0,3.2,2.6,5.8,5.8,5.8c1.3,0,2.4-0.4,3.4-1.1L13.4,14.8z"/>
                                                            </svg>
                                                        </span>
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
        <hr class="nhsd-a-horizontal-rule nhsd-!t-margin-0" />
    </header>
</#macro>