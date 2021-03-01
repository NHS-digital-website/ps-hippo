<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">

<#macro azList navigationDocument ariaLabel="">
    <#assign lettersOfTheAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]/>

    <#assign navList = [] />
    <#if navigationDocument.blocks??>
        <#assign navList = navigationDocument.blocks />
        <#assign alphabetical_hash = group_blocks(flat_blocks(navList true))/>
    <#elseif navigationDocument.glossaryItems??>
        <#assign navList = navigationDocument.glossaryItems />
        <#assign alphabetical_hash = group_blocks(navList)/>
    </#if>

    <#if ariaLabel?? && ariaLabel?has_content>
        <#assign ariaLabel = "aria-labelledby=" + ariaLabel/>
    </#if>

    <nav class="nhsd-m-character-block-list" ${ariaLabel}>
        <ul>
            <#list lettersOfTheAlphabet as letter>
                <#if alphabetical_hash[letter]??>
                    <li>
                        <a class="nhsd-a-character-block" href="<@hst.link hippobean=navigationDocument/>#${letter?lower_case}">${letter}</a>
                    </li>
                <#else>
                    <li>
                        <span class="nhsd-a-character-block nhsd-a-character-block--disabled">${letter}</span>
                    </li>
                </#if>
            </#list>
        </ul>
    </nav>
</#macro>
