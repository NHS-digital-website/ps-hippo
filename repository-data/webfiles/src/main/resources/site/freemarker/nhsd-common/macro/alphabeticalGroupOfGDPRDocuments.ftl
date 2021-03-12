<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<@hst.setBundle basename="rb.doctype.gdpr-summary"/>

<#assign lettersOfTheAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]/>
<#assign matchesFound = 0/>

<#macro alphabeticalGroupOfGDPRDocuments gdprDocumentGroups>
<#if gdprDocumentGroups?has_content>
<#list lettersOfTheAlphabet as letter>
    <#if gdprDocumentGroups[letter]??>
    <#assign matchesFound++ />

    <div class="article-section article-section--letter-group" id="${slugify(letter)}">
        <div class="grid-row sticky sticky--top">
            <div class="column column--reset">
                <div class="article-header article-header--tertiary">
                    <div class="grid-row">
                        <div class="column column--reset">
                            <h2 class="article-header__title">${letter}</h2>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="grid-row">
            <div class="column column--reset">
                <div class="list list--reset cta-list cta-list--sections cta-list--sections-busy">
                    <#list gdprDocumentGroups[letter] as gdprDocument>
                    
                    <#assign hasBlocks = gdprDocument.blocks?? && gdprDocument.blocks?size!=0 />

                    <article class="cta cta--gdpr-summary">
                        <div class="grid-row">
                            <div class="column column--reset">
                                <h2 class="cta__title"><a href="<@hst.link hippobean=gdprDocument />">${gdprDocument.title}</a></h2>
                            </div>
                        </div>

                        <div class="grid-row">
                            <div class="column column--reset column--rights">
                                <h3 class="cta__subtitle"><@fmt.message key="labels.your-rights"/></h3>

                                <ul class="checklist checklist--condensed">
                                    <#list rights?keys as key>
                                        <li class="checklist__item">
                                            <#if gdprDocument.rights?seq_contains(key)>
                                                <img src="<@hst.webfile path="images/icon-tick.png"/>" alt="Tick" class="checklist__icon checklist__icon--small" />
                                            <#else>
                                                <img src="<@hst.webfile path="images/icon-cross.png"/>" alt="Tick" class="checklist__icon checklist__icon--small" />
                                            </#if>
                                            <span class="checklist__label">${rights[key]}</span>
                                        </li>                                                
                                    </#list>
                                </ul>
                            </div>
                        </div>

                        <div class="grid-row">
                            <div class="column column--one-quarter column--reset">
                                <h3 class="cta__subtitle"><@fmt.message key="labels.lawful-basis"/></h3>
                                <#if gdprDocument.lawfulbasis?has_content>
                                    <div class="cta__meta">${lawfulbasis[gdprDocument.lawfulbasis]}</div>
                                </#if>
                            </div>

                            <#if hasBlocks>
                            <div class="column column--one-half column--reset">
                                <h3 class="cta__subtitle"><@fmt.message key="labels.asset-used-by"/></h3>
                                <ul class="list cta-list">
                                    <#list gdprDocument.blocks as block>
                                    <li>
                                        <article class="cta">
                                            <#if block.linkType == "internal">
                                                <h2 class="cta__meta cta__meta--reset-bottom"><a href="<@hst.link hippobean=block.link />">${block.link.title}</a></h2>
                                            <#else>
                                                <#assign onClickMethodCall = getOnClickMethodCall(document.class.name, block.link) />
                                                <h2 class="cta__meta cta__meta--reset-bottom"><a href="${block.link}" onClick="${onClickMethodCall}" onKeyUp="return vjsu.onKeyUp(event)">${block.title}</a></h2>
                                            </#if>
                                        </article>
                                    </li>
                                    </#list>
                                </ul>
                            </div>
                            </#if>
                        </div>
                    </article>
                    </#list>
                </div>
            </div>
        </div>
    </div>
    </#if>
</#list>
</#if>
</#macro>
