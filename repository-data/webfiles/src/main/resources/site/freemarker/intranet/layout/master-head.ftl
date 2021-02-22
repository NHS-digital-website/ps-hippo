<#ftl output_format="HTML">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="format-detection" content="telephone=no">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <@hst.headContributions categoryIncludes="metadata" xhtml=true />

    <!-- Generic meta tags -->
    <@hst.headContributions categoryExcludes="htmlBodyEnd, scripts" categoryIncludes="intranetMeta" xhtml=true/>

    <#-- Preload fonts to improve performance -->
    <link rel="preload" href="<@hst.webfile path="fonts/FrutigerLTW01-55Roman.woff2" />" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<@hst.webfile path="fonts/FrutigerLTW01-56Italic.woff2" />" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<@hst.webfile path="fonts/FrutigerLTW01-65Bold.woff2" />" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="<@hst.webfile path="fonts/FrutigerLTW01-66BoldItalic.woff2" />" as="font" type="font/woff2" crossorigin>

    <#-- Preconnect to 3rd parties to improve proformance -->
    <link rel="preconnect" href="https://in.hotjar.com" crossorigin>
    <link rel="preconnect" href="https://vars.hotjar.com" crossorigin>
    <link rel="preconnect" href="https://accdn.lpsnmedia.net" crossorigin>
    <link rel="preconnect" href="https://lpcdn.lpsnmedia.net" crossorigin>
    <link rel="preconnect" href="https://lptag.liveperson.net" crossorigin>

    <!--[if IE]><link rel="shortcut icon" href="<@hst.webfile path="icons/favicon.ico"/>"><![endif]-->
    <link rel="apple-touch-icon" sizes="180x180" href="<@hst.webfile path="icons/apple-touch-icon.png"/>">
    <link rel="icon" type="image/png" sizes="32x32" href="<@hst.webfile path="icons/favicon-32x32.png"/>">
    <link rel="icon" type="image/png" sizes="16x16" href="<@hst.webfile path="icons/favicon-16x16.png"/>">
    <link rel="manifest" href="<@hst.webfile path="icons/manifest.json"/>">
    <link rel="mask-icon" href="<@hst.webfile path="icons/safari-pinned-tab.svg"/>">
    <meta name="theme-color" content="#ffffff">

    <link rel="stylesheet" href="<@hst.webfile path="/dist/nhsd-intranet.css"/>" media="screen" type="text/css"/>
    <link rel="stylesheet" href="<@hst.webfile path="/dist/nhsd-intranet-print.css"/>" media="print" type="text/css"/>

    <script defer src="<@hst.webfile path="/dist/intranet-scripts.bundle.js"/>"></script>

    <#include "../scripts/intranet-header-scripts.ftl" />
</head>
