<#ftl output_format="HTML">
<#include "../../include/imports.ftl">

<#assign logoPath = useIntraLogo?then("nhs-digital-intranet-logo", "nhs-digital-logo--right-aligned") />
<@hst.webfile var="nhsDigitalLogo" path="/images/${logoPath}.svg" />
<@hst.webfile var="printCSSFilePath" path="/dist/nhsuk-print-pdf-document.css" />
<@hst.link var="documentUrl" hippobean=document />

<#assign currentDateTime = .now />
<@fmt.formatDate var="formattedCurrentDate" value=currentDateTime type="Date" pattern="d MMMM yyyy" timeZone="${getTimeZone()}" />

<#include "image-loader.js.ftl" />

<script>
    /*<!CDATA[[*/
    $(function() {
        var pdfPrinter = {};
        var _this = pdfPrinter;

        var $articleEl = $('.article');
        if (!$articleEl) {
            return;
        }

        // Fetch the current document's related document links if available via the `data` attribute
        _this.relatedDocumentLinks = $articleEl.attr('data-related-doc-links') ? $articleEl.attr('data-related-doc-links').split('; ') : [];

        // Self invoking kick off method
        (function init() {
            // Create iframe
            _this.iframe = document.createElement('iframe');
            _this.iframe.setAttribute('src', 'about:blank');
            _this.iframe.setAttribute('id', 'print-pdf-iframe');
            _this.iframe.setAttribute('class', 'visually-hidden');
            document.body.appendChild(_this.iframe);

            // Initialise the button
            _this.button = document.querySelector('#print-pdf-button');
            $(_this.button).on('click', function(e) {
                startFetchingRelatedDocuments();
            });

            // Prepare the image preloader
            prepareImagePreloading();
        })();

        function prepareImagePreloading() {
            if (!_this.imageLoader) {
                _this.imageLoader = new ImageLoader();

                /*$(_this.imageLoader).on('progress', function (e, progress) {
                  console.log('Image loading progress: ', (progress * 100) + '%');
                });*/
                $(_this.imageLoader).on('completed', function() {
                    setTimeout(function() {
                        logGoogleAnalyticsEvent('Button click','Download as PDF', window.location.href);

                        var browserName = navigator.userAgent.toLowerCase();
                        _this.iframe.focus();

                        if ( browserName.indexOf("msie") != -1) { // old IE
                            _this.iframe.print();
                        } else if(browserName.indexOf("trident") != -1) { //IE 11
                            _this.iframe.contentWindow.document.execCommand('print', false, null);
                        } else {
                            _this.iframe.contentWindow.print();
                        }
                    }, 1000);
                });
            }
        }

        function stitchDocuments() {
            // Create a main container and add the current document's contents
            var $documentArticleHeaderEl = $(document).find('.article .article-header');
            var $documentArticleEl = $(document).find('.article .page-block--main');
            var $mainContainerEl = $('<main id="main-content"><div class="print-pdf-logo"><img src="${nhsDigitalLogo}" alt="NHSDigital logo" /></div><article class="article"><header>' + $documentArticleHeaderEl.html() + '</header><div class="grid-wrapper grid-wrapper--article"><div class="grid-row"><div class="column column--reset">' + $documentArticleEl.html() + '</div></div></div></article></main>');

            var $printInfo = $('<div class="article-header__info"><p>PDF created on ${formattedCurrentDate}. Not controlled. Latest version available online at: <a href="${documentUrl}">${documentUrl}</a></p></div>');
            $printInfo.insertBefore($mainContainerEl.find('.article-header__types'));

            // Add the related document contents as individual articles
            if (typeof _this.$relatedDocumentContents !== 'undefined') {
                for (var i = 0; i < _this.$relatedDocumentContents.length; i++) {
                    var $documentContentsEl = _this.$relatedDocumentContents[i];

                    if (!$documentContentsEl.length) {
                        continue;
                    } else {
                        $('<article class="article"><div class="grid-wrapper grid-wrapper--article"><div class="grid-row"><div class="column column--reset">' + $documentContentsEl.html() + '</div></div></div></article>').insertAfter($mainContainerEl.find('.article').last());
                    }
                }
            }

            // Remove charts and map charts
            $mainContainerEl.find('[data-uipath="ps.publication.chart-section"]').parent().remove();

            // Remove cta buttons
            $mainContainerEl.find('.ctabtn--div').parent().remove();

            // Open the details elements
            $mainContainerEl.find('details').attr('open', 'open');

            // Prepare the image preloading
            _this.imageSources = [];
            $mainContainerEl.find('img').each(function(index, imgEl) {
                _this.imageSources.push(imgEl.getAttribute('src'));
            });
            _this.imageLoader.reset();
            _this.imageLoader.addToQueue(_this.imageSources);

            // Render the contents
            renderContent($mainContainerEl.html());
        }

        // Render the html content into the iframe using print styling
        function renderContent(htmlContent) {
            // Prepare the HTML document
            var documentSource =  '<html class="print-pdf-document"><head>';
            documentSource += '<link rel="stylesheet" href="${printCSSFilePath}" />';
            documentSource += '</head>';
            documentSource += '<body>';
            documentSource += '</body></html>';

            // Write the HTML document into the iframe
            var iframeDoc = _this.iframe.contentWindow.document;
            iframeDoc.open('text/html', 'replace');
            iframeDoc.write(documentSource);
            iframeDoc.close();

            // Use the MOCK content
            iframeDoc.body.innerHTML = htmlContent;


///////// DEBUGGING PRINTING IN A NEW WINDOW
            /*var win = window.open('Print PDF Document');
            win.document.write(documentSource);
            win.document.body.innerHTML = htmlContent;
            win.document.close();*/
/////////

            // Preload the images to make sure everything prints fine
            _this.imageLoader.loadQueue();
        }


        /////////////
        //////////////// Related document
        ///

        function startFetchingRelatedDocuments() {
            if (_this.relatedDocumentLinks.length) {
                _this.$relatedDocumentContents = [];
                _this.currentDocumentIndex = 0;

                fetchRelatedDocument(_this.relatedDocumentLinks[_this.currentDocumentIndex], onRelatedDocumentFetched);
            } else {
                finishFetchingRelatedDocuments();
            }
        }

        function fetchRelatedDocument(documentUrl, successCallback) {
            if (!documentUrl) {
                return;
            }

            $.ajax({
                type: 'GET',
                url: documentUrl,
                dataType: 'html',

                success: function (response) {
                    if (typeof successCallback === 'function') {
                        successCallback.call(this, response);
                    }
                },

                error: function (xhr, ajaxOptions, thrownError) {
                    console.error('There was an error when trying to access the following document URL: [' + documentUrl + ']');
                }
            });
        }

        function onRelatedDocumentFetched(response) {
            _this.$relatedDocumentContents.push(parseDocumentResponse(response));

            ++_this.currentDocumentIndex;

            if (_this.currentDocumentIndex < _this.relatedDocumentLinks.length) {
                fetchRelatedDocument(_this.relatedDocumentLinks[_this.currentDocumentIndex], onRelatedDocumentFetched);
            } else {
                finishFetchingRelatedDocuments();
            }
        }

        function finishFetchingRelatedDocuments() {
            stitchDocuments();
        }

        function parseDocumentResponse(documentResponse) {
            var $articleContents = $(documentResponse).find('.page-block--main');
            if (!$articleContents.length) {
                return;
            }

            return $articleContents;
        }
    });
    /*]]>*/
</script>
