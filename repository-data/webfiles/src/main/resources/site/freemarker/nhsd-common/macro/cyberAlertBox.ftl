<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro cyberAlertBox options>
    <#if options??>
        <#assign isNewStyle=options.newStyle?has_content && options.newStyle />

        <#if options.severity??>
            <#assign severityColour=(options.severity?lower_case == "high")?then("red", "blue") />
        <#else>
            <#assign severityColour="grey" />
        </#if>

        <#assign severityLabel=options.severityLabel?has_content?then(options.severityLabel+":","Severity:") />
        <#assign dateLabel=options.dateLabel?has_content?then(options.dateLabel+":","Date:") />

        <article class="hub-box${(isNewStyle)?then(" hub-box--cyber-alert", "")}${options.colSize?has_content?then(" hub-box--col-${options.colSize}", "")}">

            <div class="hub-box__contents${(isNewStyle)?then(" hub-box__contents--${severityColour}", "")}">

                <#if options.threatId?? && !isNewStyle>
                    <span class="cta__label" data-uipath="ps.search-results.result.type">${options.threatId}</span>
                </#if>

                <#if options.title??>
                    <h2 class="hub-box__title" ${options.key???then("id=${options.key}", "")}>
                        <#if options.link??>
                            <a href="${options.link}">
                        </#if>
                        ${options.title}
                        <#if options.link??>
                            </a>
                        </#if>
                    </h2>

                    <#if options.key??>
                        <#-- call function webkitLineClamp(element, lineCount, colour) to implement multiline ellipsis -->
                        <script>
                            webkitLineClamp(document.getElementById("${options.key}"), 3, "white");
                        </script>
                    </#if>
                </#if>

                <#if options.publishedDate?? && !isNewStyle>
                    <span class="hub-box__meta">Published: ${options.publishedDate}, Last updated: ${options.lastModifiedDate}</span>
                    <span class="hub-box__meta"></span>
                </#if>

                <#if options.text??>
                    <p class="hub-box__text">${options.text}</p>
                </#if>

                <ul class="tag-list">
                    <#if options.severity??>
                        <li class="tag">${severityLabel} ${options.severity?cap_first}</li>
                    </#if>
                    <#if options.threatType?? && !isNewStyle>
                        <li class="tag">Type: ${options.threatType?cap_first}</li>
                    </#if>
                    <#if options.publishedDate?? && isNewStyle>
                        <li class="tag tag--right">${dateLabel} ${options.publishedDate}</li>
                    </#if>
                </ul>

            </div>
        </article>
    </#if>
</#macro>
