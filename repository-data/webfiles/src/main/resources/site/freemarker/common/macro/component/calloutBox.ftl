<#ftl output_format="HTML">

<#macro calloutBox callout>
    <#assign severity=(callout.severity?has_content?then(callout.severity, "information")) />
    <#assign update=callout.calloutType=="update" />
    <#assign survey=callout.calloutType=="survey" />
    <#assign interactive=callout.calloutType=="interactive" />
    <#assign change=callout.calloutType=="change" />
    <#assign headerElement=(update||change)?then("h2", "span") />
    <#assign calloutBoxId=callout.calloutType+"-"+callout.severity+"-"+callout.index />

    <#--  MODIFIERS  -->
    <#assign modYellowIcon=(callout.iconYellow?has_content && callout.iconYellow)?then(" callout-box--important-yellow", "") />
    <#assign modLightHeader=interactive?then(" callout-box__content-heading--light", "") />
    <#assign modNarrowIcon=(callout.narrow?has_content && callout.narrow)?then(" callout-box__icon--narrow", "") />
    <#assign modNarrowContent=(callout.narrow?has_content && callout.narrow)?then(" callout-box__content--narrow", "") />
    <#assign modNarrowHeader=(callout.narrow?has_content && callout.narrow)?then(" callout-box__content--narrow-heading", "") />

    <div class="callout-box callout-box--${severity}${modYellowIcon}" role="complementary" aria-labelledby="callout-box-heading-${calloutBoxId}">
        <div class="callout-box__icon-wrapper">
            <svg class="callout-box__icon${modNarrowIcon}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" preserveAspectRatio="xMidYMid meet" aria-hidden="true" focusable="false">
                <#if callout.severity == "important">
                    <#if survey>
                        <path d="M160,39.3H83.8c-34.6,0-62.7,28.3-62.7,63.1v12c0,19.6,8.9,37.1,22.7,48.6c-8,14.9-17.7,29.7-25.2,31.8c0,0,31.1-5.2,51.8-18.8c4.3,0.9,8.7,1.5,13.3,1.5H160c34.6,0,62.7-28.3,62.7-63.1v-12C222.7,67.6,194.6,39.3,160,39.3z"/>
                        <path d="M68,122.9c-7.6,0-13.7-6.1-13.7-13.7c0-13.7,14.6-29.5,14.6-29.5h7.9c0,0-7,7.8-10.9,16c0.7-0.1,1.3-0.2,2-0.2c7.6,0,13.7,6.1,13.7,13.7C81.7,116.8,75.5,122.9,68,122.9z"/>
                        <path d="M101.8,121.7c-7.6,0-13.7-6.1-13.7-13.7c0-13.7,14.6-29.5,14.6-29.5h7.9c0,0-7,7.8-10.9,16c0.7-0.1,1.3-0.2,2-0.2c7.6,0,13.7,6.1,13.7,13.7C115.5,115.6,109.4,121.7,101.8,121.7z"/>
                        <path d="M173.4,92.7c7.6,0,13.7,6.1,13.7,13.7c0,13.7-14.6,29.5-14.6,29.5h-7.9c0,0,7-7.8,10.9-16c-0.7,0.1-1.3,0.2-2,0.2c-7.6,0-13.7-6.1-13.7-13.7C159.7,98.9,165.8,92.7,173.4,92.7z"/>
                        <path d="M139.5,93.9c7.6,0,13.7,6.1,13.7,13.7c0,13.7-14.6,29.5-14.6,29.5h-7.9c0,0,7-7.8,10.9-16c-0.7,0.1-1.3,0.2-2,0.2c-7.6,0-13.7-6.1-13.7-13.7C125.8,100,132,93.9,139.5,93.9z"/>
                    <#else>
                        <path d="M42.7,148.5,73.9,95.9l36.8-62.1a11,11,0,0,1,18.8,0L225,195.1a10.86,10.86,0,0,1-9.4,16.4H24.4A10.88,10.88,0,0,1,15,195.1h0C23,181.7,35.4,160.8,42.7,148.5Z" transform="translate(-11.47 -26.48)"/>
                        <path fill="#005EB8" d="M124.4,161.7h-8.5L114,82.3h12.1ZM114,174.4h12.1V187H114Z" transform="translate(-11.47 -26.48)"/>
                    </#if>
                <#elseif callout.severity == "critical">
                    <path d="M47,145.78,19.54,192.3h0a10.83,10.83,0,0,0,9.33,16.35H219.1a10.84,10.84,0,0,0,10.84-10.84,10.71,10.71,0,0,0-1.5-5.51l-95.12-161a10.84,10.84,0,0,0-18.67,0L78,93.29Z" transform="translate(-16.03 -23.97)"/>
                    <path d="M111.4,178a13.28,13.28,0,0,1,1-5.21,12.72,12.72,0,0,1,2.82-4.27,13,13,0,0,1,4.27-2.82,13.91,13.91,0,0,1,10.42,0,12.85,12.85,0,0,1,7.09,7.09,13.91,13.91,0,0,1,0,10.42,12.85,12.85,0,0,1-7.09,7.09,13.91,13.91,0,0,1-10.42,0,13,13,0,0,1-4.27-2.82,12.72,12.72,0,0,1-2.82-4.27A13.28,13.28,0,0,1,111.4,178Zm24.17-21.42H113.86V71.29h21.71Z" transform="translate(-16.03 -23.97)"/>
                <#elseif interactive>
                    <path d="M198,182H42c-6.6,0-12-5.4-12-12V74c0-6.6,5.4-12,12-12h156c6.6,0,12,5.4,12,12v96C210,176.6,204.6,182,198,182z"/>
                    <line x1="30" y1="92" x2="210" y2="92"/>
                    <line x1="60" y1="114" x2="180" y2="114"/>
                    <line x1="60" y1="135" x2="180" y2="135"/>
                    <line x1="60.1" y1="156" x2="141.1" y2="156"/>
                    <circle cx="46.8" cy="77.1" r="3.7"/>
                    <circle cx="61.8" cy="77.1" r="3.7"/>
                    <circle cx="76.8" cy="77.1" r="3.7"/>
                    <rect x="166.2" y="149.1" width="13.8" height="13.8"/>
                <#elseif change>
                    <path d="M147.5,103.4l-9.5-5.5c-1.4-0.8-2.2-2.4-2-4c0.2-1.7,0.3-3.5,0.3-5.2c0-2.2-0.1-4.4-0.4-6.5c-0.2-1.7,0.6-3.3,2-4.1l9-5.2c2-1.1,2.6-3.6,1.5-5.6L134,42.5c-1.1-2-3.6-2.6-5.6-1.5l-9.5,5.5c-1.4,0.8-3.2,0.7-4.5-0.2c-3.2-2.3-6.6-4.2-10.2-5.7c-1.5-0.7-2.5-2.1-2.5-3.8V26.3c0-2.3-1.8-4.1-4.1-4.1H69c-2.3,0-4.1,1.8-4.1,4.1v11c0,1.6-1,3.1-2.5,3.7c-3.6,1.6-7,3.6-10,6c-1.3,1-3.1,1.1-4.5,0.3l-9-5.2c-2-1.1-4.5-0.5-5.6,1.5L18.9,68.4c-1.1,2-0.5,4.5,1.5,5.6l9.5,5.5c1.4,0.8,2.2,2.4,2,4c-0.2,1.7-0.3,3.5-0.3,5.2c0,2.2,0.1,4.4,0.4,6.5c0.2,1.7-0.6,3.3-2,4.1l-9,5.2c-2,1.1-2.6,3.6-1.5,5.6l14.3,24.8c1.1,2,3.6,2.6,5.6,1.5l9.5-5.5c1.4-0.8,3.2-0.7,4.5,0.2c3.2,2.3,6.6,4.2,10.2,5.7c1.5,0.6,2.5,2.1,2.5,3.8v10.4c0,2.3,1.8,4.1,4.1,4.1h28.7c2.3,0,4.1-1.8,4.1-4.1v-11c0-1.6,1-3.1,2.4-3.7c3.6-1.6,6.9-3.6,10.1-6c1.3-1,3.1-1.1,4.6-0.3l9,5.2c2,1.1,4.5,0.5,5.6-1.5L149,109C150.1,107,149.5,104.5,147.5,103.4z M83.9,119.4c-16.9,0-30.7-13.7-30.7-30.7C53.2,71.7,67,58,83.9,58s30.7,13.7,30.7,30.7C114.6,105.6,100.9,119.4,83.9,119.4z"/>
                    <path d="M220.8,187.4l-6.4-3.7c-0.9-0.5-1.5-1.6-1.4-2.7c0.1-1.2,0.2-2.3,0.2-3.5c0-1.5-0.1-2.9-0.3-4.4c-0.1-1.1,0.4-2.2,1.4-2.8l6.1-3.5c1.3-0.8,1.8-2.4,1-3.8l-9.6-16.7c-0.8-1.3-2.4-1.8-3.8-1l-6.4,3.7c-0.9,0.6-2.1,0.5-3-0.2c-2.1-1.5-4.4-2.8-6.9-3.9c-1-0.4-1.7-1.4-1.7-2.6v-7c0-1.5-1.2-2.8-2.8-2.8h-19.3c-1.5,0-2.8,1.2-2.8,2.8v7.4c0,1.1-0.6,2.1-1.6,2.5c-2.4,1.1-4.7,2.4-6.8,4c-0.9,0.7-2.1,0.8-3.1,0.2l-6.1-3.5c-1.3-0.8-3-0.3-3.8,1l-9.6,16.7c-0.8,1.3-0.3,3,1,3.8l6.4,3.7c0.9,0.5,1.5,1.6,1.4,2.7c-0.1,1.2-0.2,2.3-0.2,3.5c0,1.5,0.1,2.9,0.3,4.4c0.1,1.1-0.4,2.2-1.4,2.8l-6.1,3.5c-1.3,0.8-1.8,2.4-1,3.8l9.6,16.7c0.8,1.3,2.4,1.8,3.8,1l6.4-3.7c0.9-0.6,2.1-0.5,3,0.2c2.1,1.5,4.4,2.8,6.9,3.9c1,0.4,1.7,1.4,1.7,2.6v7c0,1.5,1.2,2.8,2.8,2.8h19.3c1.5,0,2.8-1.2,2.8-2.8v-7.4c0-1.1,0.6-2.1,1.6-2.5c2.4-1.1,4.7-2.4,6.8-4c0.9-0.7,2.1-0.8,3.1-0.2l6.1,3.5c1.3,0.8,3,0.3,3.8-1l9.6-16.7C222.6,189.8,222.1,188.1,220.8,187.4z M178,198.2c-11.4,0-20.7-9.2-20.7-20.7c0-11.4,9.2-20.7,20.7-20.7s20.7,9.2,20.7,20.7C198.7,188.9,189.4,198.2,178,198.2z"/>
                <#else>
                    <path fill="#005EB8" d="M120.6,145h4.6c-3,6.2-7,11.7-11.8,16.6c-4.9,4.9-9.5,7.2-14.1,7.2c-3,0-5.7-1.1-7.9-3.3c-2.2-2.1-3.4-5.3-3.4-9.5c0-3.4,1.8-9.9,5.4-19.6l11-29.3c2.6-6.8,3.8-11,3.8-12.5c0-1.3-0.3-2.2-0.9-2.9c-0.7-0.7-1.6-0.9-2.8-0.9c-2.5,0-5.5,2-8.9,5.8c-3.4,3.9-5.9,7.4-7.2,10.5h-4.6c3.6-7,7.5-12.5,12.1-16.6c4.6-4.1,8.8-6,12.6-6c3,0,5.5,1.1,7.4,3c2,2.1,2.9,4.7,2.9,8.2c0,3.4-1.7,9.6-5.1,18.7l-9.2,25c-3.4,9.1-5.1,14.7-5.1,17.1c0,1.8,0.4,3.3,1.1,4.2c0.8,0.9,1.8,1.4,3.3,1.4C108.7,161.9,114.2,156.3,120.6,145z M113.5,42c0-2.4,0.8-4.3,2.5-5.9s3.6-2.5,5.9-2.5c2.4,0,4.3,0.8,5.9,2.5c1.6,1.7,2.5,3.6,2.5,5.9c0,2.4-0.8,4.3-2.5,5.9c-1.6,1.7-3.6,2.5-5.9,2.5s-4.3-0.8-5.9-2.5C114.3,46.2,113.5,44.2,113.5,42z"/>
                    <circle cx="110.5" cy="110.5" r="108.5"/>
                </#if>
            </svg>
        </div>

        <div class="callout-box__content${modNarrowContent}">

            <${headerElement} class="callout-box__content-heading${modLightHeader}${modNarrowHeader}" id="callout-box-heading-${calloutBoxId}">
                <#if interactive && callout.link?has_content>
                    <a href="${callout.link}">${callout.title}</a>
                <#else>
                    ${callout.title}
                </#if>
            </${headerElement}>

            <div class="callout-box__content-description">
                <#if survey>
                    <p>${callout.content}</p>
                    <p><a href="${callout.link}">${callout.text}</a></p>
                <#else>
                    <@hst.html hippohtml=callout.content contentRewriter=gaContentRewriter />
                </#if>

                <#if interactive>
                    <#if !callout.accessible && callout.accessiblelocation?has_content>
                        <p class="callout-box__content-not-accessible">${callout.notAccessiblePrimaryText}</p>
                        <div class="expander expander-some no-top-margin">
                            <details>
                                <summary aria-expanded="false" aria-controls="details-content-${callout.index}">
                                    <span>${callout.notAccessibleSummaryText}</span>
                                </summary>
                                <div class="details-body" aria-hidden="true" id="details-content-${callout.index}">
                                    <@hst.html hippohtml=callout.accessiblelocation.content contentRewriter=gaContentRewriter />
                                    <p><a href="${callout.accessiblelocation.link}">${callout.accessiblelocation.title}</a></p>
                                </div>
                            </details>
                        </div>
                    </#if>
                </#if>

                <#if callout.date?has_content>
                    <p class="callout-box__content-description-date">
                        ${callout.dateLabel?has_content?then(callout.dateLabel, "")}
                        ${callout.date}
                    </p>
                </#if>
            </div>
        </div>
    </div>
</#macro>
