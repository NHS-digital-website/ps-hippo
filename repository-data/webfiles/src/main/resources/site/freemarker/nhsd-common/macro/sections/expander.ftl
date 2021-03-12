<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Expander" -->

<#macro expander section heading="" content="">
    <div class="article-section-with-no-heading expander ${(section != "" && section.audience?? && section.audience == "Most people")?then("expander-most", "expander-some")} navigationMarker-sub">
        <details>
            <summary>
                <span>
                    <#if heading?has_content>
                      ${heading}
                    <#else>
                      ${section.heading}
                    </#if>
                </span>
            </summary>
            <div class="details-body">
                <#if content?has_content>
                  <@hst.html hippohtml=content />
                <#else>
                  <@hst.html hippohtml=section.content />
                </#if>
            </div>
        </details>
    </div>
</#macro>
