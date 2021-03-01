<#ftl output_format="HTML">
<#include "./macro/nhsd/az-nav.ftl">

<#if navigationDocument??>
    <div class="nhsd-t-grid nhsd-!t-margin-bottom-9">
        <div class="nhsd-t-row nhsd-t-row--centred">
            <div class="nhsd-t-col-12">
                <#assign ariaLabel = ""/>
                <#if headerText?? && headerText?has_content>
                    <h2 id="nhsd-az-nav-heading" class="nhsd-t-heading-m">${headerText}</h2>
                    <#assign ariaLabel = "nhsd-az-nav-heading"/>
                </#if>

                <@azList navigationDocument ariaLabel/>

                <#if buttonText?? && buttonText?has_content>
                    <a class="nhsd-a-button nhsd-!t-margin-bottom-0 nhsd-!t-margin-top-5" href="<@hst.link hippobean=navigationDocument/>">${buttonText}</a>
                </#if>
            </div>
        </div>
    </div>
</#if>
