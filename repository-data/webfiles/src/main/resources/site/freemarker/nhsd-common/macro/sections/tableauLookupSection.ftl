<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">
<#-- @ftlvariable name="section" type="uk.nhs.digital.website.beans.TableauLookup" -->

<#macro tableauLookup section index>

    <@hst.setBundle basename="tableau.postcode.labels, tableau.lables, tableau.postcode.configuration"/>

   <#if section?? && section.url??>

        <@hst.headContribution>
            <script src="${section.tableauBase}javascripts/api/tableau-2.min.js"></script>
        </@hst.headContribution>

        <#assign divId = "tableau-${index}"/>

       <div class="eforms">
           <form action="javascript:void(0);">
               <div class="eforms-field" style="max-width: 300px">
                   <label for="${divId}-postcode" class="eforms-label"><@fmt.message key="postcode-label"/><span class="eforms-req"></span></label>
                   <input type="text" id="${divId}-postcode" />
                   <div id="${divId}-postcode-validation-message" class="eforms-field__error-message visually-hidden"></div>
                   <span class="eforms-hint"><@fmt.message key="postcode-hint"/></span>
               </div>
               <div class="eforms-field" style="max-width: 300px">
                   <label for="${divId}-distance" class="eforms-label"><@fmt.message key="distance-label"/><span class="eforms-req"></span></label>
                   <select id="${divId}-distance" style="margin-top: 8px;">
                       <option value="1">1 mile</option>
                       <option value="2">2 miles</option>
                       <option selected value="3">3 miles</option>
                       <option value="4">4 miles</option>
                       <option value="5">5 miles</option>
                       <option value="6">6 miles</option>
                       <option value="7">7 miles</option>
                       <option value="8">8 miles</option>
                       <option value="9">9 miles</option>
                       <option value="10">10 miles</option>
                   </select>
                   <span class="eforms-hint"><@fmt.message key="distance-hint"/></span>
               </div>
               <div class="eforms-buttons">
                   <input class="button" type="submit" value="Go" onclick="lookup()"/>
               </div>
           </form>

       </div>

       <div id="${divId}" class="viz-wrapper">
           <div id="${divId}-viz" class="viz-wrapper-item"></div>
           <div id="${divId}-loading" class="viz-wrapper-item visually-hidden">
               <div class="viz-wrapper-loading">
                   <span id="${divId}-loading-message"></span>
                   <div class="viz-wrapper-loading-icon">
                       <img id="${divId}-loading-icon" src="<@hst.webfile  path="images/loading-circle.gif"/>" alt="Loading data " />
                   </div>
               </div>
           </div>
       </div>

        <script>
            var vizMessages = {
                LOAD_ERROR: "<@fmt.message key="load-error"/>",
                LOADING_MESSAGE: "<@fmt.message key="loading-message"/>",
                LOADING_MESSAGE_LONGER: "<@fmt.message key="loading-message-longer"/>",
                LOADING_FAILED_MESSAGE: "<@fmt.message key="loading-failed-message"/>"
            };
        </script>

        <script>

            // Viz instance
            var viz${index};

            // Helper varables
            var viz${index}Url;
            var viz${index}Loaded;
            var viz${index}LoadingTimerStart;
            var viz${index}LoadingRetryAtempIntervales;
            var viz${index}LoadingTimer;

            // Viz instance supporting HTML elements
            var viz${index}Elements = {
                vizDiv: function () {
                    return document.getElementById("${divId}-viz");
                },
                validationMessageDiv: function () {
                    return document.getElementById("${divId}-postcode-validation-message");
                },
                loadingDiv: function () {
                    return document.getElementById("${divId}-loading");
                },
                loadingIcon: function () {
                    return document.getElementById("${divId}-loading-icon");
                },
                loadingMessage: function (){
                    return document.getElementById("${divId}-loading-message");
                },
                postcode: function () {
                    return document.getElementById("${divId}-postcode");
                },
                distance: function () {
                    return document.getElementById("${divId}-distance");
                }
            };

            function loadViz() {
                function options() {
                    var options = {
                        "onFirstInteractive": function () {
                            viz${index}Load = true;
                            clearInterval(viz${index}LoadingTimer);
                            _hideLoadingSpinner();
                        },
                        hideTabs: ${section.hidetabs?string},
                        hideToolbar: true
                        <#if section.device??>
                        ,device: "${section.device}"
                        </#if>
                    };
                    if(options.device && options.device === "default"){
                        if(window.matchMedia("(min-width: 924px)").matches) {
                            options.device = "desktop";
                        }
                    }
                    return options;
                }
                if(typeof tableau !== 'undefined' && typeof tableau.Viz !== 'undefined') {
                    if(!!viz${index}) {
                        viz${index}.dispose();
                    }
                    viz${index} = new tableau.Viz(viz${index}Elements.vizDiv(), viz${index}Url, options());
                } else {
                    _showLoadingError();
                }
            }

            function _showLoadingError() {
                viz${index}Elements.containerDiv().innerHTML = vizMessages.LOAD_ERROR;
            }

            function lookup() {
                _clearValidationMessage(viz${index}Elements.validationMessageDiv());

                fetch(postcodeApiUrl(viz${index}Elements.postcode().value))
                    .then(response => {
                        if (!response.ok) {
                            // Rejected if not a 2xx response.
                            throw response;
                        }
                        return response.json()
                    })
                    .then(data => {
                        // Make Viz URL
                        var msoa = data["result"]["msoa"];
                        var postcode = data["result"]["postcode"];
                        var latitude = data["result"]["latitude"];
                        var longitude = data["result"]["longitude"];
                        viz${index}Url = encodeURI("${section.url}".split("?")[0] + "?MSOA Code=" + msoa + "&Lat=" + latitude + "&Lon=" + longitude + "&Distance=" + parseInt(viz${index}Elements.distance().value) + "&Postcode=" + postcode + "&:refresh=yes");

                        // Start Viz load
                        _hideLoadingSpinner()
                        loadViz();
                        _showLoadingSpinner();

                        // Init loading retry
                        viz${index}Loaded = false;
                        viz${index}LoadingTimerStart = Date.now();
                        viz${index}LoadingRetryAtempIntervales = [<#list section.retryIntervals as intervale>${intervale},</#list>];
                        clearInterval(viz${index}LoadingTimer); <#-- if set -->
                        viz${index}LoadingTimer = setInterval(_retry, 1000);

                    }).catch(error => error.json().then(data => {
                        if(!!viz${index}) {
                            viz${index}.dispose();
                        }
                        if(data.hasOwnProperty('error')){
                            _showValidationMessage(viz${index}Elements.validationMessageDiv(), data["error"]);
                        } else {
                            _showValidationMessage(viz${index}Elements.validationMessageDiv(), vizMessages.LOAD_ERROR);
                        }
                }));
            }

            function postcodeApiUrl(input) {
                function _formatPostcode() {
                    if ((typeof input === 'string' || input instanceof String) && input.length >= 5) {
                        var postcode = input.split(" ").join("");;
                        postcode = postcode.toUpperCase();
                        return postcode.substr(0, postcode.length - 3) + "/" + postcode.substr(postcode.length - 3);
                    } else {
                        return null;
                    }
                }
                return "<@fmt.message key="postcode-api-address"/>" + _formatPostcode() + ".json";
            }

            function _clearValidationMessage(el) {
                if(el instanceof HTMLElement) {
                    el.innerText = "";
                    el.classList.add("visually-hidden");
                }
            }

            function _showValidationMessage(el, message) {
                if(el instanceof HTMLElement) {
                    el.innerText = message;
                    el.classList.remove("visually-hidden");
                }
            }

            function _showLoadingSpinner() {
                var loaderDiv = viz${index}Elements.loadingDiv();
                if (loaderDiv instanceof HTMLElement) {
                    loaderDiv.classList.remove("visually-hidden");
                }
                var loaderIcon = viz${index}Elements.loadingIcon();
                if (loaderIcon instanceof HTMLElement) {
                    loaderIcon.classList.remove("visually-hidden");
                }
                var message = viz${index}Elements.loadingMessage();
                if (message instanceof HTMLElement) {
                    message.classList.add("viz-wrapper-loading-message");
                    _setMessage(vizMessages.LOADING_MESSAGE);
                }
            }

            function _hideLoadingSpinner() {
                var loader = viz${index}Elements.loadingDiv();
                if (loader instanceof HTMLElement) {
                    loader.classList.add("visually-hidden");
                }
                var message = viz${index}Elements.loadingMessage();
                if (message instanceof HTMLElement) {
                    message.classList.remove("viz-wrapper-loading-message");
                }
            }

            function _setMessage(message) {
                var message${index} = viz${index}Elements.loadingMessage();
                if(!!(message${index})) {
                    message${index}.innerHTML = message;
                }
            }

            function _retry() {
                if(!viz${index}Loaded && viz${index}LoadingRetryAtempIntervales.length <= 0){
                    clearInterval(viz${index}LoadingTimer);
                    _fail();
                } else {
                    if(!viz${index}Loaded && (Date.now() - viz${index}LoadingTimerStart) > (viz${index}LoadingRetryAtempIntervales[0] * 1000)){
                        viz${index}LoadingTimerStart += viz${index}LoadingRetryAtempIntervales.shift() * 1000;  <#-- Update for the next round -->
                        _setMessage(vizMessages.LOADING_MESSAGE_LONGER);
                        loadViz();
                    }
                }
            }

            function _fail(){
                setTimeout(function(){
                    if(!viz${index}Loaded) {
                        var loading${index} = viz${index}Elements.loadingIcon();
                        if(!!(loading${index})) {
                            if (loading${index} instanceof HTMLElement) {
                                loading${index}.classList.add("visually-hidden");
                            }
                        }
                        _setMessage(vizMessages.LOADING_FAILED_MESSAGE);
                    }
                }, 60000); <#-- Allow Tableau last atempt to load finish before showing the fail message. -->
            }
        </script>
    </#if>
</#macro>
