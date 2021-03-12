<#ftl output_format="HTML">

<#function getGridCol items size="" offset=false>
    <#--
    Generate grid columns based on items and size

    Key: D=Desktop, T=Tablet, M=Mobile

    @param items (number) (required) = no. of items.
    @param size (string) (optional) = "large", "small" or "" (default).
    @return (string) of responsive grid columns based on size and number of items
    -->
    <#local col = "" />

    <#-- 4 or greater items scenario -->
    <#if items gte 4>
        <#if size == "large">
            <#-- 2D2T -->
            <#local col = "nhsd-t-col-s-6" />
        <#elseif size == "small">
            <#if offset>
                <#-- 4D3T with offset -->
                <#local col = "nhsd-t-col-s-4 nhsd-t-col-l-3 nhsd-t-off-s-2 nhsd-t-off-l-0" />
            <#else>
                <#-- 4D3T smaller 3 col on tablet using s-4 -->
                <#local col = "nhsd-t-col-s-4 nhsd-t-col-l-3" />
            </#if>
        <#else>
            <#-- DEFAULT: 4D2T -->
            <#local col = "nhsd-t-col-s-6 nhsd-t-col-l-3" />
        </#if>
    </#if>

    <#-- 3 items scenario -->
    <#if items == 3>
        <#if size == "large">
            <#-- 2D2T -->
            <#local col = "nhsd-t-col-s-6" />
        <#elseif size == "small">
            <#-- 3D3T smaller 3 col on desktop using l-3 -->
            <#local col = "nhsd-t-col-s-4 nhsd-t-col-l-3" />
        <#else>
            <#-- DEFAULT: 3D3T -->
            <#local col = "nhsd-t-col-s-4" />
        </#if>
    </#if>

    <#-- 2 items scenario -->
    <#if items lte 2>
        <#if size == "small">
            <#-- 3D3T smaller 2 col on desktop using l-3 -->
            <#local col = "nhsd-t-col-s-4 nhsd-t-col-l-3" />
        <#else>
            <#-- DEFAULT: 2D2T -->
            <#local col = "nhsd-t-col-s-6" />
        </#if>
    </#if>

    <#return col />
</#function>
