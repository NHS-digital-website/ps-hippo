<#ftl output_format="HTML">
<#include "../../../include/imports.ftl">

<#-- 
Usage of macro in your .ftl file:
   1. Create wrapper div and add class name 'filter-parent' to it 
   2. To the wrapper div add properties: 
        - data-state="short" 
        - data-max-count="maxItemsToDisplay" 
   3. Inside wrapper create series of HTML elements (ex. divs) to show/hide and add class="filter-list__item" to each of the element 
   4. add showAll macro and pass 3 params: overallNumberOfItems and maxItemsToDisplay 
     - overallNumberOfItems 
     - maxItemsToDisplay 
     - (optional) showLessStylingClass - class which is used for styling showAll/showLess button 
    5. include showAll.ftl file in your ftl file
 -->

<#-- Sample FTL structure could look like this one:
<div class="column filter-parent" data-max-count="${maxItemsToDisplay}" data-state="short">
  <div class="filter-list__item">Element 1 to show/hide</div>   
  <div class="filter-list__item">Element 2 to show/hide</div>
  <div class="filter-list__item">Element 3 to show/hide</div>
  ...
  <\@showAll overallNumberOfItems maxItemsToDisplay />
</div>
-->

<#assign showAllNumber = 0 />

<#macro showAll itemsSize maxCount showAllStylingClass=''>

    <#assign showAllNumber = showAllNumber + 1 />

    <#if itemsSize &gt; maxCount >
      <div class="filter-vis-toggles-${showAllNumber} ${showAllStylingClass}">
        <a href="#" class="filter-vis-toggle--show">Show all (${itemsSize})</a>
        <a href="#" class=" filter-vis-toggle--hide is-hidden">Show less (${maxCount})</a>
      </div>
    </#if>

    <script>
        (function(){
            var oldBrowser = window.addEventListener ? false : true;
            var $visToggles = document.getElementsByClassName('filter-vis-toggles-${showAllNumber}');
            var $filterParent = document.getElementsByClassName('filter-parent');

            var vjsUtils = window.vanillaJSUtils;

            function init () {
                for (var i = 0; i < $visToggles.length; i ++) {
                    var $visToggle = $visToggles[i];

                    if (!oldBrowser) {
                        $visToggle.addEventListener('click', handleVisToggleClick);
                    } else {
                        $visToggle.attachEvent('onclick', handleVisToggleClick);
                    }
                }

                for(var i = 0; i < $filterParent.length; i ++) {
                    hideListItems($filterParent[i]);
                }
            }

            function toggleUl(ulElement) {
                var $showToggleButton = ulElement.getElementsByClassName('filter-vis-toggle--show')[0];
                var $hideToggleButton = ulElement.getElementsByClassName('filter-vis-toggle--hide')[0];

                if ('full' == ulElement.dataset.state) {
                    hideListItems(ulElement);
                    ulElement.dataset.state = 'short';

                    vjsUtils.removeClass($showToggleButton, 'is-hidden');
                    vjsUtils.addClass($hideToggleButton, 'is-hidden');
                } else {
                    showListItems(ulElement);
                    ulElement.dataset.state = 'full'

                    vjsUtils.addClass($showToggleButton, 'is-hidden');
                    vjsUtils.removeClass($hideToggleButton, 'is-hidden');
                }
            }

            function toggleFilterSectionEl(filterSectionElement) {
                vjsUtils.toggleClass(filterSectionElement, 'is-open');
            }

            function hideListItems(ulElement) {
                setDisplayItems(ulElement);
            }

            function showListItems(ulElement) {
                setDisplayItems(ulElement, true);
            }

            function setDisplayItems(ulElement, display) {
                var listItems = ulElement.getElementsByClassName('filter-list__item');

                for (var i = 0; i < listItems.length; i ++) {
                    var listItem = listItems[i];

                    if (i >= ulElement.dataset.maxCount) {
                        if (display) {
                            vjsUtils.removeClass(listItem, 'is-hidden');
                        } else {
                            vjsUtils.addClass(listItem, 'is-hidden');
                        }
                    }
                }
            }

            function handleVisToggleClick(event) {
                var ulElement = event.target.parentNode.parentNode;

                toggleUl(ulElement);

                event.preventDefault();
                return true;
            }

            init();
        }());
    </script>

</#macro>
