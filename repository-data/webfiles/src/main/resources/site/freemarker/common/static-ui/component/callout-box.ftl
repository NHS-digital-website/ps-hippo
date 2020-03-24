<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">
<#include "../../macro/component/icon.ftl">
<#include "../../../common/macro/stickyNavSections.ftl">

<#assign index = ["Update", "Survey", "Interactive Tool", "Change of Notice", "CSS Modifiers"] />


<div class="grid-row">
    <div class="column column--one-third page-block--sticky-nav page-block--sidebar article-section-nav-outer-wrapper">
        <!-- start sticky-nav -->
        <div id="sticky-nav">
            <#assign links = [] />

            <#list index as i>
                <#assign links += [{ "url": "#" + slugify(i), "title": i }] />
            </#list>

            <@stickyNavSections getStickySectionNavLinks({"sections": links})></@stickyNavSections>
        </div>
        <!-- end sticky-nav -->
    </div>

    <div class="column column--two-thirds">
        <div class="article-section article-section--summary">
            <h1>Call out Box</h1>
        </div>

        <div class="article-section article-section--summary" id="${slugify("Update")}">
            <h2>Update box</h2>
            <p>An update box can be emphasized in 3 different styles; Critical, Important and Information.</p>
            <div class="callout-box callout-box--information" role="complementary" aria-labelledby="callout-box-heading-information">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path fill="#005EB8" d="M120.6,145h4.6c-3,6.2-7,11.7-11.8,16.6c-4.9,4.9-9.5,7.2-14.1,7.2c-3,0-5.7-1.1-7.9-3.3c-2.2-2.1-3.4-5.3-3.4-9.5c0-3.4,1.8-9.9,5.4-19.6l11-29.3c2.6-6.8,3.8-11,3.8-12.5c0-1.3-0.3-2.2-0.9-2.9c-0.7-0.7-1.6-0.9-2.8-0.9c-2.5,0-5.5,2-8.9,5.8c-3.4,3.9-5.9,7.4-7.2,10.5h-4.6c3.6-7,7.5-12.5,12.1-16.6c4.6-4.1,8.8-6,12.6-6c3,0,5.5,1.1,7.4,3c2,2.1,2.9,4.7,2.9,8.2c0,3.4-1.7,9.6-5.1,18.7l-9.2,25c-3.4,9.1-5.1,14.7-5.1,17.1c0,1.8,0.4,3.3,1.1,4.2c0.8,0.9,1.8,1.4,3.3,1.4C108.7,161.9,114.2,156.3,120.6,145z M113.5,42c0-2.4,0.8-4.3,2.5-5.9s3.6-2.5,5.9-2.5c2.4,0,4.3,0.8,5.9,2.5c1.6,1.7,2.5,3.6,2.5,5.9c0,2.4-0.8,4.3-2.5,5.9c-1.6,1.7-3.6,2.5-5.9,2.5s-4.3-0.8-5.9-2.5C114.3,46.2,113.5,44.2,113.5,42z"/>
                        <circle cx="110.5" cy="110.5" r="108.5"/>
                    </svg>
                </div>

                <div class="callout-box__content">
                    <h2 class="callout-box__content-heading" id="callout-box-heading-information">Update box (information)</h2>
                    <div class="callout-box__content-description">
                        <p>It was popularised in the 1960s with the release of Letraset sheets <a href="#">This is a link</a> containing Lorem Ipsum passages.</p>
                        <p>and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>
                    </div>
                </div>
            </div>

            <div class="callout-box callout-box--important" role="complementary" aria-labelledby="callout-box-heading-important">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 217.07 187.02" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M42.7,148.5,73.9,95.9l36.8-62.1a11,11,0,0,1,18.8,0L225,195.1a10.86,10.86,0,0,1-9.4,16.4H24.4A10.88,10.88,0,0,1,15,195.1h0C23,181.7,35.4,160.8,42.7,148.5Z" transform="translate(-11.47 -26.48)"/>
                        <path fill="#005EB8" d="M124.4,161.7h-8.5L114,82.3h12.1ZM114,174.4h12.1V187H114Z" transform="translate(-11.47 -26.48)"/>
                    </svg>
                </div>

                <div class="callout-box__content">
                    <h2 class="callout-box__content-heading" id="callout-box-heading-important">Update box (important)</h2>

                    <div class="callout-box__content-description">
                        <p>It was popularised in the 1960s with the release of Letraset sheets <a href="#">This is a link</a> containing Lorem Ipsum passages.</p>
                        <p>and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>
                    </div>
                </div>
            </div>

            <div class="callout-box callout-box--critical" role="complementary" aria-labelledby="callout-box-heading-critical">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 215.92 186.68" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M47,145.78,19.54,192.3h0a10.83,10.83,0,0,0,9.33,16.35H219.1a10.84,10.84,0,0,0,10.84-10.84,10.71,10.71,0,0,0-1.5-5.51l-95.12-161a10.84,10.84,0,0,0-18.67,0L78,93.29Z" transform="translate(-16.03 -23.97)"/>
                        <path d="M111.4,178a13.28,13.28,0,0,1,1-5.21,12.72,12.72,0,0,1,2.82-4.27,13,13,0,0,1,4.27-2.82,13.91,13.91,0,0,1,10.42,0,12.85,12.85,0,0,1,7.09,7.09,13.91,13.91,0,0,1,0,10.42,12.85,12.85,0,0,1-7.09,7.09,13.91,13.91,0,0,1-10.42,0,13,13,0,0,1-4.27-2.82,12.72,12.72,0,0,1-2.82-4.27A13.28,13.28,0,0,1,111.4,178Zm24.17-21.42H113.86V71.29h21.71Z" transform="translate(-16.03 -23.97)"/>
                    </svg>
                </div>
                <div class="callout-box__content">
                    <h2 class="callout-box__content-heading" id="callout-box-heading-critical">Update box (critical)</h2>

                    <div class="callout-box__content-description">
                        <p>It was popularised in the 1960s with the release of Letraset sheets <a href="#">This is a link</a> containing Lorem Ipsum passages.</p>
                        <p>and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="article-section article-section--summary" id="${slugify("Survey")}">
            <h2>Survey box</h2>
            <div class="callout-box callout-box--important callout-box--important-yellow" role="complementary" aria-labelledby="callout-box-heading-survey">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon callout-box__icon--narrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M160,39.3H83.8c-34.6,0-62.7,28.3-62.7,63.1v12c0,19.6,8.9,37.1,22.7,48.6c-8,14.9-17.7,29.7-25.2,31.8c0,0,31.1-5.2,51.8-18.8c4.3,0.9,8.7,1.5,13.3,1.5H160c34.6,0,62.7-28.3,62.7-63.1v-12C222.7,67.6,194.6,39.3,160,39.3z"/>
                        <path d="M68,122.9c-7.6,0-13.7-6.1-13.7-13.7c0-13.7,14.6-29.5,14.6-29.5h7.9c0,0-7,7.8-10.9,16c0.7-0.1,1.3-0.2,2-0.2c7.6,0,13.7,6.1,13.7,13.7C81.7,116.8,75.5,122.9,68,122.9z"/>
                        <path d="M101.8,121.7c-7.6,0-13.7-6.1-13.7-13.7c0-13.7,14.6-29.5,14.6-29.5h7.9c0,0-7,7.8-10.9,16c0.7-0.1,1.3-0.2,2-0.2c7.6,0,13.7,6.1,13.7,13.7C115.5,115.6,109.4,121.7,101.8,121.7z"/>
                        <path d="M173.4,92.7c7.6,0,13.7,6.1,13.7,13.7c0,13.7-14.6,29.5-14.6,29.5h-7.9c0,0,7-7.8,10.9-16c-0.7,0.1-1.3,0.2-2,0.2c-7.6,0-13.7-6.1-13.7-13.7C159.7,98.9,165.8,92.7,173.4,92.7z"/>
                        <path d="M139.5,93.9c7.6,0,13.7,6.1,13.7,13.7c0,13.7-14.6,29.5-14.6,29.5h-7.9c0,0,7-7.8,10.9-16c-0.7,0.1-1.3,0.2-2,0.2c-7.6,0-13.7-6.1-13.7-13.7C125.8,100,132,93.9,139.5,93.9z"/>
                    </svg>
                </div>

                <div class="callout-box__content callout-box__content--narrow">
                    <span class="callout-box__content-heading callout-box__content--narrow-heading" id="callout-box-heading-survey">Give us your feedback on this publication</span>

                    <div class="callout-box__content-description">
                        <p>We'd love to knw what you think of this publication, including how you use it, and any ideas for improvement.</p>
                        <p><a href="#">Complete our online customer satisfaction survey</a></p>
                        <p class="callout-box__content-description-date">Expires: 01 January 2020</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="article-section article-section--summary" id="${slugify("Interactive Tool")}">
            <h2>Interactive tool</h2>
            <div class="callout-box callout-box--grey" role="complementary" aria-labelledby="callout-box-heading-interactive-1">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon callout-box__icon--narrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M198,182H42c-6.6,0-12-5.4-12-12V74c0-6.6,5.4-12,12-12h156c6.6,0,12,5.4,12,12v96C210,176.6,204.6,182,198,182z"/>
                        <line x1="30" y1="92" x2="210" y2="92"/>
                        <line x1="60" y1="114" x2="180" y2="114"/>
                        <line x1="60" y1="135" x2="180" y2="135"/>
                        <line x1="60.1" y1="156" x2="141.1" y2="156"/>
                        <circle cx="46.8" cy="77.1" r="3.7"/>
                        <circle cx="61.8" cy="77.1" r="3.7"/>
                        <circle cx="76.8" cy="77.1" r="3.7"/>
                        <rect x="166.2" y="149.1" width="13.8" height="13.8"/>
                    </svg>
                </div>

                <div class="callout-box__content callout-box__content--narrow">
                    <span class="callout-box__content-heading callout-box__content-heading--light callout-box__content--narrow-heading" id="callout-box-heading-interactive-1">
                        <a href="#">Interactive dashboard</a>
                    </span>

                    <div class="callout-box__content-description">
                        <p>An interactive tool in PowerBI showing the workforce figures by Clinical Commissioning Group</p>
                        <p class="callout-box__content-description-date">Expires: 01 January 2020</p>
                    </div>
                </div>
            </div>

            <div class="callout-box callout-box--grey" role="complementary" aria-labelledby="callout-box-heading-interactive-2">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon callout-box__icon--narrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M198,182H42c-6.6,0-12-5.4-12-12V74c0-6.6,5.4-12,12-12h156c6.6,0,12,5.4,12,12v96C210,176.6,204.6,182,198,182z"/>
                        <line x1="30" y1="92" x2="210" y2="92"/>
                        <line x1="60" y1="114" x2="180" y2="114"/>
                        <line x1="60" y1="135" x2="180" y2="135"/>
                        <line x1="60.1" y1="156" x2="141.1" y2="156"/>
                        <circle cx="46.8" cy="77.1" r="3.7"/>
                        <circle cx="61.8" cy="77.1" r="3.7"/>
                        <circle cx="76.8" cy="77.1" r="3.7"/>
                        <rect x="166.2" y="149.1" width="13.8" height="13.8"/>
                    </svg>
                </div>

                <div class="callout-box__content  callout-box__content--narrow">
                    <span class="callout-box__content-heading callout-box__content-heading--light callout-box__content--narrow-heading" id="callout-box-heading-interactive-2">
                        <a href="#">Interactive dashboard</a>
                    </span>

                    <div class="callout-box__content-description">
                        <p>An interactive tool in PowerBI showing the workforce figures by Clinical Commissioning Group</p>

                        <p class="callout-box__content-not-accessible">This tool may not be fully accessible for all users</p>
                        <div class="expander expander-some no-top-margin">
                            <details>
                                <summary aria-expanded="false" aria-controls="details-content-0">
                                    <span>Find out how to access this information</span>
                                </summary>
                                <div class="details-body" aria-hidden="true" id="details-content-0">
                                    <p>Distinctively pontificate seamless potentialities whereas enterprise-wide materials. Quickly grow superior opportunities vis-a-vis progressive leadership skills. Distinctively administrate innovative channels without cutting-edge collaboration and idea-sharing. Compellingly optimize visionary deliverables and highly efficient products. Completely leverage other's fully tested channels whereas ubiquitous niche markets.</p>
                                    <p><a href="#">Workforce in General Practice 2018</a></p>
                                </div>
                            </details>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="article-section article-section--summary" id="${slugify("Change of Notice")}">
            <h2>Change of notice</h2>
            <div class="callout-box callout-box--information" role="complementary" aria-labelledby="callout-box-heading-change">
                <div class="callout-box__icon-wrapper">
                    <svg class="callout-box__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                        <path d="M147.5,103.4l-9.5-5.5c-1.4-0.8-2.2-2.4-2-4c0.2-1.7,0.3-3.5,0.3-5.2c0-2.2-0.1-4.4-0.4-6.5c-0.2-1.7,0.6-3.3,2-4.1l9-5.2c2-1.1,2.6-3.6,1.5-5.6L134,42.5c-1.1-2-3.6-2.6-5.6-1.5l-9.5,5.5c-1.4,0.8-3.2,0.7-4.5-0.2c-3.2-2.3-6.6-4.2-10.2-5.7c-1.5-0.7-2.5-2.1-2.5-3.8V26.3c0-2.3-1.8-4.1-4.1-4.1H69c-2.3,0-4.1,1.8-4.1,4.1v11c0,1.6-1,3.1-2.5,3.7c-3.6,1.6-7,3.6-10,6c-1.3,1-3.1,1.1-4.5,0.3l-9-5.2c-2-1.1-4.5-0.5-5.6,1.5L18.9,68.4c-1.1,2-0.5,4.5,1.5,5.6l9.5,5.5c1.4,0.8,2.2,2.4,2,4c-0.2,1.7-0.3,3.5-0.3,5.2c0,2.2,0.1,4.4,0.4,6.5c0.2,1.7-0.6,3.3-2,4.1l-9,5.2c-2,1.1-2.6,3.6-1.5,5.6l14.3,24.8c1.1,2,3.6,2.6,5.6,1.5l9.5-5.5c1.4-0.8,3.2-0.7,4.5,0.2c3.2,2.3,6.6,4.2,10.2,5.7c1.5,0.6,2.5,2.1,2.5,3.8v10.4c0,2.3,1.8,4.1,4.1,4.1h28.7c2.3,0,4.1-1.8,4.1-4.1v-11c0-1.6,1-3.1,2.4-3.7c3.6-1.6,6.9-3.6,10.1-6c1.3-1,3.1-1.1,4.6-0.3l9,5.2c2,1.1,4.5,0.5,5.6-1.5L149,109C150.1,107,149.5,104.5,147.5,103.4z M83.9,119.4c-16.9,0-30.7-13.7-30.7-30.7C53.2,71.7,67,58,83.9,58s30.7,13.7,30.7,30.7C114.6,105.6,100.9,119.4,83.9,119.4z"/>
                        <path d="M220.8,187.4l-6.4-3.7c-0.9-0.5-1.5-1.6-1.4-2.7c0.1-1.2,0.2-2.3,0.2-3.5c0-1.5-0.1-2.9-0.3-4.4c-0.1-1.1,0.4-2.2,1.4-2.8l6.1-3.5c1.3-0.8,1.8-2.4,1-3.8l-9.6-16.7c-0.8-1.3-2.4-1.8-3.8-1l-6.4,3.7c-0.9,0.6-2.1,0.5-3-0.2c-2.1-1.5-4.4-2.8-6.9-3.9c-1-0.4-1.7-1.4-1.7-2.6v-7c0-1.5-1.2-2.8-2.8-2.8h-19.3c-1.5,0-2.8,1.2-2.8,2.8v7.4c0,1.1-0.6,2.1-1.6,2.5c-2.4,1.1-4.7,2.4-6.8,4c-0.9,0.7-2.1,0.8-3.1,0.2l-6.1-3.5c-1.3-0.8-3-0.3-3.8,1l-9.6,16.7c-0.8,1.3-0.3,3,1,3.8l6.4,3.7c0.9,0.5,1.5,1.6,1.4,2.7c-0.1,1.2-0.2,2.3-0.2,3.5c0,1.5,0.1,2.9,0.3,4.4c0.1,1.1-0.4,2.2-1.4,2.8l-6.1,3.5c-1.3,0.8-1.8,2.4-1,3.8l9.6,16.7c0.8,1.3,2.4,1.8,3.8,1l6.4-3.7c0.9-0.6,2.1-0.5,3,0.2c2.1,1.5,4.4,2.8,6.9,3.9c1,0.4,1.7,1.4,1.7,2.6v7c0,1.5,1.2,2.8,2.8,2.8h19.3c1.5,0,2.8-1.2,2.8-2.8v-7.4c0-1.1,0.6-2.1,1.6-2.5c2.4-1.1,4.7-2.4,6.8-4c0.9-0.7,2.1-0.8,3.1-0.2l6.1,3.5c1.3,0.8,3,0.3,3.8-1l9.6-16.7C222.6,189.8,222.1,188.1,220.8,187.4z M178,198.2c-11.4,0-20.7-9.2-20.7-20.7c0-11.4,9.2-20.7,20.7-20.7s20.7,9.2,20.7,20.7C198.7,188.9,189.4,198.2,178,198.2z"/>
                    </svg>
                </div>

                <div class="callout-box__content">
                    <h2 class="callout-box__content-heading" id="callout-box-heading-change">Change of notice</h2>

                    <div class="callout-box__content-description">
                        <p>Added missing data in column C of the spreadsheet</p>
                        <p class="callout-box__content-description-date">Published: 01 January 2020 09:21 AM</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="article-section article-section--summary" id="${slugify("CSS Modifiers")}">
            <h2>CSS Modifiers</h2>
            <ul>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box--information</code></pre>
                    <p>Usage: Apply the <code>information</code> modifier if you want a <span style="background-color: #d4e4f3">BLUE</span> colour based callout box</p>
                    <p>Location: Applied on the parent callout box.</p>
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box--important</code></pre>
                    <p>Usage: Apply the <code>important</code> modifier if you want a <span style="background-color: #fff1cc">YELLOW</span> colour based callout box</p>
                    <p>Location: Applied on the parent callout box.
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box--critical</code></pre>
                    <p>Usage: Apply the <code>critical</code> modifier if you want a <span style="background-color: #af1224; color: #ffffff">RED</span> colour based callout box</p>
                    <p>Location: Applied on the parent callout box.
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box--grey</code></pre>
                    <p>Usage: Apply the <code>grey</code> modifier if you want a <span style="background-color: #98A4AD">GREY</span> colour based callout box</p>
                    <p>Location: Applied on the parent callout box.
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box--important-yellow</code></pre>
                    <p>Usage: To apply a yellow colour based icon on the callout box. This is only to be used on the <code>important</code> modifier mentioned above.</p>
                    <p>Location: Applied on the parent callout box, in addition to the <code>callout-box--important</code> element (as seen on the survey callout type).</p>
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box__content-heading--light</code></pre>
                    <p>Usage: To apply a non-bold font weight to the callout box header.</p>
                    <p>Location: Applied on the <code>h2</code> or <code>span</code> element for the callout box content heading.</p>
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box__icon--narrow</code></pre>
                    <p>Usage: Gives the callout out box icon a smaller dimension.</p>
                    <p>Location: Apply on the <code>svg</code> element</p>
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box__content--narrow</code></pre>
                    <p>Usage: Gives the callout box content the ability to use the full width, with 0 <code>padding-left</code></p>
                    <p>Location: Apply in addition to the <code>callout-box__content</code> element</p>
                </li>
                <li style="margin-bottom: 20px">
                    <pre style="font-weight: 600"><code>callout-box__content--narrow-heading</code></pre>
                    <p>Usage: Gives the callout box content heading the left padding to display inline with the icon.</p>
                    <p>Location: Applied on the <code>h2</code> or <code>span</code> element for the callout box content heading.</p>
                </li>
            </ul>
        </div>
    </div>

</div>
