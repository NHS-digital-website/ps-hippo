<#ftl output_format="HTML">
<#macro contentPixel itemId itemName>
    <script type="text/javascript">
        if ("${itemId}" && "${itemName}"){
            var br_data = br_data || {};
            br_data.ptype = "content";
            br_data.item_id = "${itemId}";
            br_data.item_name = "${itemName}";
        }
    </script>
</#macro>
