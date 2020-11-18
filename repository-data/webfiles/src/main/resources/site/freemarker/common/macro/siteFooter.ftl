<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<@hst.setBundle basename="emails"/>

<#macro siteFooter narrowLayout=false>
    <#-- BR Javascript Pixel -->
    <#include "../scripts/br-global-pixel-script.ftl">

    <footer class="site-footer white-links" id="footer">
        <div class="grid-wrapper grid-wrapper--full-width grid-wrapper--wide">
            <div class="grid-row">
                <div class="column column--reset">

                    <div class="site-footer__section site-footer__section--top">
                        <div class="grid-wrapper grid-wrapper--collapse">
                            <div class="grid-row">
                                <div class="column column--left ${narrowLayout?then('column--one-half', 'column--three-quarters')}">
                                    <nav class="site-footer__menu site-footer__menu--1">
                                        <h2 class="list__header">About NHS Digital</h2>
                                        <ul class="list list--reset list--close">
                                            <li><a href="/about-nhs-digital">About us</a></li>
                                            <li><a href="/about-nhs-digital/corporate-information-and-documents/our-strategy">Our strategy</a></li>
                                            <li><a href="/about-nhs-digital/corporate-information-and-documents/nhs-digital-s-annual-reports-and-accounts">Annual report and accounts</a></li>
                                            <li><a href="/about-nhs-digital/corporate-information-and-documents/nhs-digital-business-plan-2018--19">Our business plan</a></li>
                                            <li><a href="/news-and-events">News and events</a></li>
                                            <li><a href="/about-nhs-digital/our-work/keeping-patient-data-safe/how-we-look-after-your-health-and-care-information">How we look after your information</a></li>
                                        </ul>
                                    </nav>
                                </div>

                                <div class="column column--right ${narrowLayout?then('column--one-half', 'column--one-quarter')}">
                                    <nav class="site-footer__menu site-footer__menu--3">
                                        <ul class="list list--reset list--close">
                                            <li><a href="/about-nhs-digital/contact-us">Contact us</a></li>
                                            <li><a href="/press-office">Press office</a></li>
                                            <li><a href="/about-nhs-digital/contact-us/freedom-of-information">Freedom of information</a></li>
                                            <li><a href="/about-nhs-digital/careers">Careers</a></li>
                                            <li class="last-item"><a href="/about-nhs-digital/tell-us-what-you-think-of-our-website" title="Provide website feedback">Tell us what you think of our website</a></li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="site-footer__section site-footer__section--bottom">
                        <div class="grid-wrapper grid-wrapper--collapse">
                            <div class="grid-row">
                                <div class="column column--left">
                                    <nav class="site-footer__menu site-footer__menu--4">
                                        <ul class="list list--inline list--reset">
                                            <li><a href="/about-nhs-digital/privacy-and-cookies">Privacy and cookies</a></li>
                                            <li><a href="/about-nhs-digital/terms-and-conditions">Terms and conditions</a></li>
                                            <li><a href="/about-nhs-digital/accessibility">Accessibility</a></li>
                                            <li><a href="javascript:Cookiebot.renew()">Cookie consent</a></li>
                                        </ul>
                                    </nav>

                                    <#if !narrowLayout>
                                    <div class="site-footer__menu site-footer__menu--5">
                                        <ul class="list list--inline list--reset">
                                            <li>
                                                <a href="https://www.linkedin.com/company/nhs-digital" onClick="${getOnClickMethodCall('Footer', 'https://www.linkedin.com/company/nhs-digital')}" onKeyUp="return vjsu.onKeyUp(event)">
                                                    <img src="<@hst.webfile  path="images/icon-linkedin.png"/>" alt="LinkedIn logo" class="image-icon" /><span>LinkedIn</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="https://twitter.com/NHSDigital" onClick="${getOnClickMethodCall('Footer', 'https://twitter.com/NHSDigital')}" onKeyUp="return vjsu.onKeyUp(event)">
                                                    <img src="<@hst.webfile  path="images/icon-twitter.png"/>" alt="Twitter logo" class="image-icon"/><span>Twitter</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
</#macro>
