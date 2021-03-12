<#ftl output_format="HTML">
<#include "imageSection.ftl">

<#macro imagePairSection section>
    <div data-uipath="ps.publication.image-pair-section">
        <div class="grid-row">
            <div class="column column--one-half">
                <@imageSection section=section.first />
            </div>
            <div class="column column--one-half">
                <#if section.second??>
                    <@imageSection section=section.second />
                </#if>
            </div>
        </div>
    </div>
</#macro>
