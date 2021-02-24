<#ftl output_format="HTML">
<#include "../include/imports.ftl">

<#assign lettersOfTheAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]/>

<#assign navList = [] />
<#if navigationDocument.blocks??>
    <#assign navList = navigationDocument.blocks />
<#elseif navigationDocument.glossaryItems??>
    <#assign navList = navigationDocument.glossaryItems />
</#if>

<#assign alphabetical_hash = group_blocks(navList)/>

<div class="nhsd-m-character-block-list nhsd-!t-margin-bottom-9">
    <div class="nhsd-t-grid nhsd-!t-no-gutters">
        <div class="nhsd-t-row nhsd-t-row--centred">
            <div class="nhsd-t-col-s-12">
                <#assign ariaLabel = ""/>
                <#if headerText?? && headerText?has_content>
                    <h2 id="nhsd-az-nav-heading" class="nhsd-t-heading-m">${headerText}</h2>
                    <#assign ariaLabel = "aria-labelledby=\"nhsd-az-nav-heading\""/>
                </#if>
                <nav class="nhsd-!t-margin-bottom-5" ${ariaLabel}>
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

                <#if buttonText?? && buttonText?has_content>
                    <a class="nhsd-a-button nhsd-!t-margin-bottom-0" href="<@hst.link hippobean=navigationDocument/>">${buttonText}</a>
                </#if>
            </div>
        </div>
    </div>
</div>
