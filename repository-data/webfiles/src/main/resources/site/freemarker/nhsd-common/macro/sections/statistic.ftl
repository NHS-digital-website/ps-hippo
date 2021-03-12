<#ftl output_format="HTML">

<#macro statOutput number prefix="" suffix="">
    <span class="statistic__prefix">${prefix}</span><span
        class='statistic__number'>${number?number}</span><span
        class="statistic__suffix">${suffix}</span>
</#macro>


<#function getPrefix type>
    <h2>type: ${type}</h2>
    <#if type == 'money' >
        <#return '£' />
    <#elseif type == 'plus' >
        <#return '+' />
    <#elseif type == 'minus' >
        <#return '-' />
    </#if>
    <#return '' />
</#function>

<#function getSuffix type>
    <#if type == 'percentage' >
        <#return '%' />
    <#elseif type == 'plus' >
        <#return '+' />
    <#elseif type == 'millions' >
        <#return 'm' />
    <#elseif type == 'billions' >
        <#return 'b' />
    <#elseif type == 'thousands' >
        <#return 'k' />
    <#elseif type == 'times' >
        <#return 'x' />
    </#if>
    <#return '' />
</#function>

<#macro statistic stat iteration>
    <#local showStatistic = false />
    <#local statisticType = stat.statisticType />

    <@hst.html hippohtml=stat.headlineDescription contentRewriter=gaContentRewriter var="desc" />
    <@hst.html hippohtml=stat.furtherQualifyingInformation contentRewriter=gaContentRewriter var="info" />
    <#local prefixText = getPrefix(stat.prefix) />
    <#local suffixText = getSuffix(stat.suffix) />

    <#if stat.statisticType == "staticStatistic">
        <#local showStatistic = true />
        <#local number = stat.number />
        <#local trend = stat.trend />
    </#if>

    <#if stat.statisticType == "feedStatistic">
        <#local remoteStat="uk.nhs.digital.freemarker.statistics.RemoteStatisticFromUrl"?new() />
        <#local remote = (remoteStat(stat.urlOfNumber))! />
        <#if remote??>
            <#local showStatistic = true />
            <#if (remote.trend)??>
                <#local trend = remote.trend />
            </#if>
            <#if (remote.prefix)??>
                <#local prefixText = remote.prefix />
            </#if>
            <#if (remote.suffix)??>
                <#local suffixText = remote.suffix />
            </#if>
            <#if (remote.number)??>
                <#local number = remote.number />
            </#if>
            <#if (remote.headline)??>
                <#local desc = "<p>" + (remote.headline)?? + "</p>" />
            </#if>
            <#if (remote.information)??>
                <#local info = "<p>" + (remote.information)?? + "</p>" />
            </#if>
        </#if>
    </#if>

    <#if showStatistic && number??>

        <#if trend??>
            <#if trend == "auto">
                <#if number?number < 0 >
                    <#local trend = 'down' />
                <#else>
                    <#local trend = 'up' />
                </#if>
            </#if>
        </#if>


       <#local numberOutput = [number]/>
        <#if number?contains('/')>
            <#local numberOutput = number?split('/') />
        </#if>

        <#local numberTypeClass = 'statistic--single-number' />
        <#if numberOutput??>
            <#if numberOutput?size gt 1>
                <#local numberTypeClass = 'statistic--fraction' />
            </#if>
        </#if>
        <#assign statClasses = ['statistic', numberTypeClass, 'statistic--colour-${iteration}'] />
        <div class="${statClasses?join(" ")}">
            <p class="statistic__numberStat">
                <#if trend??>
                    <#if trend == 'up' >
                        <span class="statistic__trend">
                            <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25"
                                 viewBox="0 0 25 25" class="statistic__trend-arrow"
                                 aria-labelledby="up-arrow-title"
                                 role="img">
                                    <title id="up-arrow-title">Upwards Trend</title>
                                    <path fill="#003087" fill-rule="nonzero"
                                          d="M17.976016 25c.428291 0 .783162-.342633.783162-.770925V12.506118h5.469897c.31816 0 .599608-.19579.721977-.489476.036711-.097895.048948-.19579.048948-.293686 0-.208027-.085658-.416054-.244738-.575134L13.044542.220264C12.885462.073421 12.70191 0 12.506118 0c-.19579 0-.379344.073421-.538423.220264L.256975 11.147822C.097895 11.306902 0 11.514929 0 11.722956c0 .097896.024474.19579.061185.293686.122369.293686.403817.489477.721977.489477h5.469897v11.722956c0 .428292.35487.770925.783162.770925h10.939795z"/>
                            </svg>
                        </span>
                    <#elseif trend == 'down' >
                        <span class="statistic__trend">
                            <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25"
                                 viewBox="0 0 25 25" class="statistic__trend-arrow"
                                 aria-labelledby="down-arrow-title"
                                 role="img">
                                <title id="down-arrow-title">Downwards Trend</title>
                                <path fill="#003087" fill-rule="nonzero"
                                      d="M17.976016 0c.428291 0 .783162.342633.783162.770925v11.722957h5.469897c.31816 0 .599608.19579.721977.489476.036711.097895.048948.19579.048948.293686 0 .208027-.085658.416054-.244738.575134l-11.71072 10.927558c-.15908.146843-.342633.220264-.538424.220264-.19579 0-.379344-.073421-.538423-.220264L.256975 13.852178C.097895 13.693098 0 13.485071 0 13.277044c0-.097896.024474-.19579.061185-.293686.122369-.293686.403817-.489477.721977-.489477h5.469897V.770925C6.25306.342633 6.60793 0 7.036221 0h10.939795z"/>
                            </svg>
                        </span>
                    </#if>
                </#if>

                <span class="statistic__number-output">
                    <#if numberOutput??>
                        <#list numberOutput as thisNumber>
                            <#if thisNumber?counter gt 1>
                                <span class="statistic__out-of-text">out of</span>
                            </#if>
                        <@statOutput number=thisNumber prefix=prefixText suffix=suffixText />
                        </#list>
                    </#if>
                </span>
            </p>
            <div class="statistic__description">${desc?no_esc}</div>

            <#if info?has_content && info?length gt 0>
                <div class="statistic__information">${info?no_esc}</div>
            </#if>
        </div>
    <#else>
        <p>The statistic is unavailable at this time. Please try again soon.</p>
    </#if>
</#macro>
