<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.ps.beans.ChartSection" -->
<#macro chartSection section type size>

    <@hst.setBundle basename="publicationsystem.headers"/>
    <@fmt.message key="headers.download-chart-data" var="downloadDataFileHeader" />
    <#local linkText>${downloadDataFileHeader} ${section.title}</#local>

    <div id="chart-${section.uniqueId}" data-uipath="ps.publication.chart-section" style="width:100%; height:${size}px;">
        <span class="css-loader"></span>
    </div>

    <#if section.dataFile?has_content>
        <#local dataFile=section.dataFile>
        <span class="attachment">
            <@externalstorageLink dataFile; url>
            <a data-uipath="ps.publication.chart-section.data-file"
               title="${linkText}"
               href="${url}"
               onClick="logGoogleAnalyticsEvent(
                   'Download chart data','Publication','${dataFile.filename}'
               );"
               onKeyUp="logGoogleAnalyticsEvent(
                   'Download chart data','Publication','${dataFile.filename}'
               );">
                ${linkText}
            </a>
            </@externalstorageLink>
        </span>
    </#if>

    <script type="text/javascript" data-chartsource="highchart" data-charttype="${type}" data-sectionid="${section.uniqueId}">
        window.highchartData${section.uniqueId?remove_beginning("-")} = <#outputformat "plainText">${section.chartConfig}</#outputformat>;
    </script>
</#macro>
