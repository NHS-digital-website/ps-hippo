<#ftl output_format="HTML">

<#include "./hub-query-filter.js.ftl"/>
<#include "./hub-tag-filter.js.ftl"/>

<script>
    (function() {
        var COMPONENT_TYPES = {
            QUERY:  'QUERY',
            TAG:    'TAG'
        };

        var SEARCH_RESULTS_EL_ID = '#hub-search-results';
        var SEARCH_PAGINATION_EL_ID = '#hub-search-pagination';
        var SEARCH_CONTENT_NAV_EL_ID = '#hub-search-page-contents';
        var FACET_NAV_WRAPPER_CLASS = '.faceted-nav-wrapper';
        var DELAY = 200;

        var _this = this;

        (function init() {
            _this.filterComponents = [];
            _this.queryFilters = {};
            _this.queryFilterComponent = null;

            _this.$sideNavigation = document.querySelectorAll('.page-block--sidebar')[0];
            _this.$searchResultsContainer = document.querySelector(SEARCH_RESULTS_EL_ID);
            _this.$searchPaginationContainer = document.querySelector(SEARCH_PAGINATION_EL_ID);
            _this.$searchContentsNavContainer = document.querySelector(SEARCH_CONTENT_NAV_EL_ID);
            _this.history = window.history || null;
            _this.poppingHistoryState = false;

            initQueryFilters();
            initTagFilters();


            if (_this.history) {
                window.addEventListener('popstate', popHistoryState);
            }
        })();

        // Instantiate tag filter components
        function initTagFilters() {
            var hubTagFilterElements = document.querySelectorAll('[data-hub-filter-type=nhsd-hub-tag-filter]');

            for (var i = 0; i < hubTagFilterElements.length; i++) {
                var component = new HubTagFilter(hubTagFilterElements[i]);

                component.onChange(handleComponentChange);
                _this.filterComponents.push(component);

                // Cache the default component values
                if (component.getDefaultValue()) {
                    updateQueryFilters(component.getKey(), component.getValue());
                }
            }
        }

        // Instantiate query filter components
        function initQueryFilters() {
            var hubQueryFilterElements = document.querySelectorAll('[data-hub-filter-type=nhsd-hub-query-filter]');

            for (var i = 0; i < hubQueryFilterElements.length; i++) {
                var component = new HubQueryFilter(hubQueryFilterElements[i]);

                // Cache the first query filter component for progress indication
                _this.queryFilterComponent = _this.queryFilterComponent ? _this.queryFilterComponent : component;

                component.onChange(handleComponentChange);

                // Cache the default component values
                if (component.getDefaultValue()) {
                    updateQueryFilters(component.getKey(), component.getValue());
                }

                _this.filterComponents.push(component);
            }
        }

        // Handle component change event emitters
        function handleComponentChange(component) {
            if (component) {
                updateQueryFilters(component.getKey(), component.getValue());
            }

            var searchParamsString = populateQueryString(_this.queryFilters);
            if (_this.cachedSearchParamsString !== searchParamsString) {
                if (_this.queryFilterComponent) {
                    _this.queryFilterComponent.showProgress();

                    _this.cachedQueryString = _this.queryFilterComponent.getValue();

                    makeDelayedFunctionCall(function () {
                        performSearch();
                    }, DELAY)();
                } else {
                    performSearch();
                }
            }
        }

        function updateQueryFilters(key, value) {
            if (typeof key === 'undefined' ||  typeof value === 'undefined') {
                return;
            }

            _this.queryFilters[key] = value;
        }

        function populateQueryString(queryFilters) {
            var queryString = '';
            var i = 0;
            for (var r in queryFilters) {
                if (queryFilters[r] == '') continue;
                queryString += (i == 0 ? '?' : '&') + r + '=' + queryFilters[r];
                i++;
            }

            return queryString;
        }

        function performSearch() {
            var searchParamsString = populateQueryString(_this.queryFilters);

            _this.cachedSearchParamsString = searchParamsString;

            if (!_this.poppingHistoryState) {
                pushHistoryState();
            }

            var xhr = new XMLHttpRequest();
            xhr.open('GET', searchParamsString, true);
            xhr.addEventListener('readystatechange', () => {
                if (xhr.readyState !== 4) {
                    return;
                }

                if (xhr.status === 200) {
                    renderSearchResults(xhr.response);
                    renderPagination(xhr.response);
                    renderSideNavLinks(xhr.response);

                    if (_this.queryFilterComponent) {
                        _this.queryFilterComponent.showProgress(true);
                    }

                    highlightSearchTerm();
                }   else {
                    console.log('An error occured while performing the search.');
                }
            });

            xhr.send();
        }

        function makeDelayedFunctionCall(callback, ms) {
            if (typeof _this.timer !== 'undefined') {
                clearTimeout(_this.timer);
                _this.timer = undefined;
            }

            return function() {
                var context = this, args = arguments;
                _this.timer = setTimeout(function () {
                    callback.apply(context, args);
                }, ms || 0);
            };
        }

        function replaceAll(str, find, replace) {
            return str.replace(new RegExp(find, 'gi'), replace);
        }

        function replaceFoundString(inputTextEl) {
            var queryString = _this.cachedQueryString;

            if (_this.cachedQueryString) {
                var innerHTML = inputTextEl.innerHTML;
                innerHTML = replaceAll(innerHTML, queryString, '<span class=\'highlight\'>'+queryString+'</span>');
                inputTextEl.innerHTML = innerHTML;
            }
        }

        function highlightSearchTerm() {
            var shortSummaries = document.querySelectorAll('.hub-box__text');
            Array.prototype.forEach.call(shortSummaries, replaceFoundString);

            var titles = document.querySelectorAll('.hub-box__title-a');
            Array.prototype.forEach.call(titles, replaceFoundString);
        }

        function renderSearchResults(data) {
            var $dataResultsContainer = $(data).find(SEARCH_RESULTS_EL_ID);
            $(_this.$searchResultsContainer).html($dataResultsContainer.html());
        }

        function renderPagination(data) {
            var $dataPaginationEl = $(data).find(SEARCH_PAGINATION_EL_ID).find('.pagination');
            if ($dataPaginationEl.length) {
                window.vjsu.removeClass(_this.$searchPaginationContainer, 'is-hidden');
                $(_this.$searchPaginationContainer).html($dataPaginationEl);
            } else {
                window.vjsu.addClass($searchPaginationContainer, 'is-hidden');
                $($searchPaginationContainer).html('');
            }
        }

        function renderSideNavLinks(data) {
            var $dataContentNavEl = $(data).find(SEARCH_CONTENT_NAV_EL_ID);

            // If Sticky nav doesn't already have the content nav element...
            if ($dataContentNavEl.length) {
                if (!$(_this.$sideNavigation).find(SEARCH_CONTENT_NAV_EL_ID).length) {
                    $(_this.$sideNavigation).find('.article-section-nav-wrapper').last().after('<div class="article-section-nav-wrapper" id="hub-search-page-contents"></div>');
                    _this.$searchContentsNavContainer = document.querySelector(SEARCH_CONTENT_NAV_EL_ID);
                }

                $(_this.$searchContentsNavContainer).html($dataContentNavEl.html());
            } else {
                $(_this.$searchContentsNavContainer).remove();
                _this.$searchContentsNavContainer = null;
            }

            // Update facets
            var facetWrapper = $(_this.$sideNavigation).find(FACET_NAV_WRAPPER_CLASS);
            if (facetWrapper.length) {
                facetWrapper.find(FACET_NAV_WRAPPER_CLASS).empty();
                var facetWrapperContent = $(data).find(FACET_NAV_WRAPPER_CLASS);
                if (facetWrapperContent.length) {
                    facetWrapper.html(facetWrapperContent);
                }
            }
        }

        function pushHistoryState() {
            var searchParamsString = populateQueryString(_this.queryFilters);
            var url = window.location.origin + window.location.pathname + searchParamsString;

            if (_this.history) {
                _this.history.pushState({queryFilters: _this.queryFilters}, null, url);
            }
        }

        function popHistoryState(e) {
            if (e.state && typeof e.state.queryFilters === 'object') {
                _this.poppingHistoryState = true;

                resetComponentValues(e.state.queryFilters);
                handleComponentChange();
            }
        }

        function resetComponentValues(queryFilters) {
            if (typeof queryFilters === 'object') {
                _this.queryFilters = queryFilters;

                for (var r in _this.filterComponents) {
                    var component = _this.filterComponents[r];

                    component.resetValue(queryFilters[component.getKey()]);
                }
            }
        }
    })();
</script>
