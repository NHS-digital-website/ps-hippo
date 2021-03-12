<#ftl output_format="HTML">
<#macro searchTabsComponent contentNames>
    <@hst.setBundle basename="feature-toggles, searchtab-labels" scope="pageContext"/>
    <@fmt.message key="feature.tabs" var="featureTabs"/>
    <#if contentNames?seq_contains("tabs") && featureTabs?boolean>

        <div class="nav-tabs">
                <#if isContentSearch?? && isContentSearch>
                    <#if searchTabs??>
                    <div data-uipath="ps.search-tabs" class="js-tabs">
                        <ul class="tabs-nav" role="tablist">
                            <#list searchTabs as tab>
                                <#if tab.name == "All">
                                    <li class="tabs-nav__item ${isAllSelected("searchTab", tab.name)?then("tabs-nav__item--active", "")}">
                                    <#else >
                                        <li class="tabs-nav__item ${isSelected("searchTab", tab.name)?then("tabs-nav__item--active", "")}">
                                </#if>

                                <#if tab.count == 0>
                                    <a tabindex="${tab?index + 0}" class="tabs-link"
                                       href="#"
                                       role="tab"
                                       style="pointer-events: none; cursor: default;">
                                        <@fmt.message key="${getTabFacetLabel(tab.name)}"/> <#if tab.name != "All">(${tab.count})</#if></a>
                                <#else>
                                    <a tabindex="${tab?index + 0}"
                                       href="${tab.facetUrl}" class="tabs-link"
                                       title="${tab.name}"
                                       role="tab"><@fmt.message key="${getTabFacetLabel(tab.name)}"/> <#if tab.name != "All">(${tab.count})</#if></a>
                                </#if>
                                </li>
                            </#list>
                        </ul>
                    </div>
                    </#if>
                <#else>
                    <@hst.include ref="tabs"/>
                </#if>
        </div>
    </#if>
</#macro>

<#function isSelected parameter value>
    <#if hstRequest.requestContext.servletRequest.getParameter(parameter)?? &&  hstRequest.requestContext.servletRequest.getParameter(parameter) == value>
        <#return  true />
    <#else>
        <#return false />
    </#if>
</#function>

<#function isAllSelected parameter value>
    <#if  hstRequest.requestContext.servletRequest.getParameter(parameter)??>
        <#return false />
        <#else >
        <#return true />
    </#if>
</#function>

<#function getTabFacetLabel field>
    <#local labels = {
    "All":              "searchtab.all",
    "data":             "searchtab.data",
    "services":         "searchtab.services",
    "news":             "searchtab.news_and_events"
    }/>
    <#return labels[field] />
</#function>
