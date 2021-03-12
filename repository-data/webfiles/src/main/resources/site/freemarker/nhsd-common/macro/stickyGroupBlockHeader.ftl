<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#macro stickyGroupBlockHeader title = "Title">
    <div class="grid-row sticky sticky--top" data-name="${slugify(title)}">
        <div class="column column--reset">
            <div class="article-header article-header--tertiary">
                <div class="grid-row">
                    <div class="column column--reset">
                        <h2 class="article-header__title">${title}</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>
