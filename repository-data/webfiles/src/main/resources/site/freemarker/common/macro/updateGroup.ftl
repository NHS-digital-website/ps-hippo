<#ftl output_format="HTML">
<#include "../../include/imports.ftl">
<#include "./component/calloutBox.ftl">

<#-- Render a group of document updates and change of notices -->
<#macro updateGroup document>
    <#if document.updates?has_content || document.changenotice?has_content>
        <div class="grid-row">
            <div class="column column--no-padding">
                <div class="callout-box-group">
                    <#if document.updates?has_content>
                        <#assign item = {} />
                        <#list document.updates as update>
                            <#assign item += update />
                            <#assign item += {"calloutType":"update", "index":update?index} />
                            <@calloutBox item />
                        </#list>
                    </#if>

                    <#if document.changenotice?has_content>
                        <#assign item = {} />
                        <#list document.changenotice as changeData>
                            <#assign item += changeData />
                            <@fmt.formatDate value=changeData.date.time type="Date" pattern="d MMMM yyyy HH:mm a" timeZone="${getTimeZone()}" var="changeDateTime" />
                            <#assign item += {"date":changeDateTime, "dateLabel":changeDateLabel} />
                            <#assign item += {"calloutType":"change", "severity":"information", "index":changeData?index} />
                            <@calloutBox item />
                        </#list>
                    </#if>
                </div>
            </div>
        </div>
    </#if>
</#macro>
