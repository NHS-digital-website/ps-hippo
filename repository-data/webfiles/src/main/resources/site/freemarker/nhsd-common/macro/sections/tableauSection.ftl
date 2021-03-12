<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">
<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.Tableau" -->

<#macro tableau section index>

    <@hst.setBundle basename="tableau.lables"/>

    <#if section?? && section.url??>
        <@hst.headContribution>
            <script src="${section.tableauBase}javascripts/api/tableau-2.min.js"></script>
        </@hst.headContribution>

        <#assign divId = "tableau-${index}"/>

        <div id="${divId}" class="viz-wrapper navigationMarker-sub">
            <#if section.placeholderImageLocation?has_content>
                <div id="${divId}-viz" class="viz-wrapper-item hidden-viz"></div>
                <img id="${divId}-placeholder" class="viz-wrapper-item" src="${section.placeholderImageLocation}" />
                <div id="${divId}-loading" class="viz-wrapper-item">
                    <div class="viz-wrapper-loading">
                        <span id="${divId}-loading-message" class="viz-wrapper-loading-message"><@fmt.message key="loading-message"/></span>
                        <img id="${divId}-loading-icon" src="<@hst.webfile  path="images/loading-circle.gif"/>" alt="Loading data " />
                    </div>
                </div>
            <#else>
                <div id="${divId}-viz" class="viz-wrapper-item"></div>
            </#if>
        </div>

        <script type="text/javascript">
            var vizMessages = {
                LOAD_ERROR: "<@fmt.message key="load-error"/>",
                LOADING_MESSAGE_LONGER: "<@fmt.message key="loading-message-longer"/>",
                LOADING_FAILED_MESSAGE: "<@fmt.message key="loading-failed-message"/>"
            };
        </script>

        <script type="text/javascript">

            // Viz instance
            var viz${index};

            // Viz instance supporting HTML elements
            var viz${index}Elements = {
                loadingDiv: function () {
                    return document.getElementById("${divId}-loading");
                },
                loadingIcon: function () {
                    return document.getElementById("${divId}-loading-icon");
                },
                loadingMessage: function (){
                    return document.getElementById("${divId}-loading-message");
                },
                placeholderImage: function () {
                    return document.getElementById("${divId}-placeholder");
                },
                vizDiv: function () {
                    return document.getElementById("${divId}-viz");
                },
                containerDiv: function () {
                    return document.getElementById("${divId}");
                }
            };

            // Setup reload attempt
            var viz${index}Load = false;
            var viz${index}LoadTimer = setInterval(_retry, 1000);

            function loadViz(containerDiv, placeholderElements) {
                var url = "${section.url}";
                var options = {
                    "onFirstInteractive": function () {
                        viz${index}Load = true;
                        clearInterval(viz${index}LoadTimer);
                        _onFirstInteractive(containerDiv, placeholderElements);
                    },
                    hideTabs: ${section.hidetabs?string}
                    <#if section.device??>
                    ,device: "${section.device}"
                    </#if>
                };
                if(typeof tableau !== 'undefined' && typeof tableau.Viz !== 'undefined') {
                    if(!!viz${index}) {
                        viz${index}.dispose();
                    }
                    viz${index} = new tableau.Viz(containerDiv, url, options);
                } else {
                    _showLoadingError();
                }
            }

            function _onFirstInteractive(containerDiv, placeholderElements){
                containerDiv.classList.remove("hidden-viz");
                if (Array.isArray(placeholderElements) && placeholderElements.length) {
                    placeholderElements.forEach(function (el) {
                        _remove(el);
                    });
                }
            }

            function _load() {
                if(!viz${index}Load) {
                    <#if section.placeholderImageLocation?has_content>
                    loadViz(viz${index}Elements.vizDiv(), [viz${index}Elements.placeholderImage(), viz${index}Elements.loadingDiv()]);
                    <#else>
                    loadViz(viz${index}Elements.vizDiv());
                    </#if>
                }
            }

            window.addEventListener('load', function() {
                _load();
            });


            // Retry timestamp
            var viz${index}StartLoadTimeStart = Date.now();
            var viz${index}RetryAtempIntervales=[<#list section.retryIntervals as intervale>${intervale},</#list>];

            function _retry() {
                if(!viz${index}Load && viz${index}RetryAtempIntervales.length <= 0){
                    clearInterval(viz${index}LoadTimer);
                    _fail();
                } else {
                    if(!viz${index}Load && (Date.now() - viz${index}StartLoadTimeStart) > (viz${index}RetryAtempIntervales[0] * 1000)){
                        viz${index}StartLoadTimeStart += viz${index}RetryAtempIntervales.shift() * 1000;  <#-- Update for the next round -->
                        _setMessage(vizMessages.LOADING_MESSAGE_LONGER);
                        _load();
                    }
                }
            }

            function _fail(){
                setTimeout(function(){
                    if(!viz${index}Load) {
                        _setMessage(vizMessages.LOADING_FAILED_MESSAGE);
                        var loading${index} = viz${index}Elements.loadingIcon();
                        if(!!(loading${index})) {
                            _remove(loading${index});
                        }
                    }
                }, 60000); <#-- Allow Tableau last atempt to load finish before showing the fail message. -->
            }

            function _setMessage(message) {
                var message${index} = viz${index}Elements.loadingMessage();
                if(!!(message${index})) {
                    message${index}.innerHTML = message;
                }
            }

            function _showLoadingError() {
                viz${index}Elements.containerDiv().innerHTML = vizMessages.LOAD_ERROR;
            }

            function _remove(element) {
                if(element instanceof HTMLElement) {
                    element.parentNode.removeChild(element);
                }
            }
        </script>
    </#if>
</#macro>
