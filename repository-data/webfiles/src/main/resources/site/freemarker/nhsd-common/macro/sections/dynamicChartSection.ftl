<#ftl output_format="HTML">

<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.DynamicChartSection" -->

<#macro dynamicChartSection section size>
    <@hst.setBundle basename="publicationsystem.headers"/>
    <@fmt.message key="headers.download-chart-data" var="downloadDataFileHeader" />
    <#local linkText>${downloadDataFileHeader} ${section.title}</#local>
    <#local getData="uk.nhs.digital.freemarker.highcharts.RemoteChartDataFromUrl"?new() />
    <#local chartData =  (getData(section.url))! />

    <div id="chart-${section.uniqueId}-block">
        <figure data-chart="highchart">
            <div id="chart-${section.uniqueId}"
                 style="width:100%; height:${size}px;">
                <span class="css-loader"></span>
            </div>
            <span class="attachment">
                <a data-uipath="ps.publication.chart-section.data-file"
                   title="${linkText}"
                   download="${slugify(section.title)}.csv"
                   <#if (chartData.data)??>
                       href="data:text/plain;base64,${chartData.data}"
                   <#else>
                       href="${section.url}" target="_blank"
                   </#if>
                   onClick="logGoogleAnalyticsEvent(
                           'Download chart data','Publication','${slugify(section.title)}'
                           );"
                   onKeyUp="logGoogleAnalyticsEvent(
                           'Download chart data','Publication','${slugify(section.title)}'
                           );">${linkText}</a>
            </span>
        </figure>
    </div>
    <script type="text/javascript" data-chartsource="highchart"
            data-charttype="chart" data-sectionid="${section.uniqueId}">
        <#if (chartData.data)??>
        var chartData = "${chartData.data}";
        var results = Papa.parse(atob(chartData));
        if (!results.errors.length) {
            </#if>
            window.highchartData${section.uniqueId?remove_beginning("-")} = {
                chart: {
                    type: '${section.type?lower_case}',
                    alignTicks: false,
                },
                <#if section.YTitle?has_content>
                yAxis: {
                    title: {
                        text: "${section.YTitle}"
                    },
                    gridLineDashStyle: 'shortdash',
                    gridLineWidth: 1
                },
                </#if>
                <#if section.XTitle?has_content>
                xAxis: {
                    title: {
                        text: "${section.XTitle}"
                    },
                    gridLineDashStyle: 'shortdash',
                    gridLineWidth: 1
                },
                </#if>
                title: {
                    text: "${section.title}"
                },
                data: {
                    <#if (chartData.data)??>
                    csv: atob(chartData),
                    <#else>
                    enablePolling: false,
                    csvURL: "${section.url}",
                    </#if>
                    firstRowAsNames: true,
                    complete: function (o) {
                        let finalSeries = []
                        let currentSeries = o.series
                        let removeValFromIndex = []
                        let seriesObj = {};
                        let seriesValue = [];
                        let seriesCount = 0
                        for (let i = 0; i < currentSeries.length; i++) {
                            let tempOne = currentSeries[i]
                            const index = currentSeries.indexOf(tempOne);
                            <#list section.seriesItem as item>
                            if ("${item.name}" == currentSeries[i].name
                                    && '${item.type}' == "suppress") {
                                if (index > -1) {
                                    removeValFromIndex[removeValFromIndex.length] = index;
                                }
                            } else if ("${item.name}" == currentSeries[i].name) {
                                seriesValue[seriesCount] = ['${item.type}', tempOne];
                                seriesObj["${item.name}"] = seriesValue[seriesCount];
                                removeValFromIndex[removeValFromIndex.length] = index;
                                seriesCount++
                            }
                            </#list>
                        }
                        for (let i = removeValFromIndex.length - 1; i >= 0; i--)
                            o.series.splice(removeValFromIndex[i], 1);
                        for (let key in seriesObj) {
                            o.series.push({
                                type: seriesObj[key][0],
                                name: key,
                                data: seriesObj[key][1].data
                            })
                        }
                    }
                }
            };
            <#if (chartData.data)??>
        } else {
            document.getElementById('chart-${section.uniqueId}-block').innerHTML = "<p><strong>The dynamic chart is unavailable at this time. Please try again soon.</strong></p>"
        }
        </#if>
    </script>
</#macro>
