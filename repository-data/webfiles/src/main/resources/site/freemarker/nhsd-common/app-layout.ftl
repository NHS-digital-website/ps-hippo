<#ftl output_format="HTML">
<#include "../include/imports.ftl">
<#include "./macro/globalHeader.ftl">

<!DOCTYPE html>
<html lang="en" class="nhsd-no-js">
    <#include "./app-layout-head.ftl">
<body>
    <div class="nhsd-t-grid nhsd-t-grid--full-width nhsd-!t-no-gutters">
        <@globalHeader true/>

        <@hst.include ref= "main"/>

        <@hst.include ref= "footer"/>

        <#include "scripts/nhsd-footer-scripts.ftl" />
    </div>
</body>
</html>

