package uk.nhs.digital.ps.test.acceptance.util;

import static org.openqa.selenium.net.Urls.urlEncode;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

public class TestContentUrls {

    private static final AtomicReference<TestContentUrls> instance = new AtomicReference<>();

    private static final String S3_BUCKET_URL = "https://files.local.nhsd.io/";

    private final Map<String, String> siteUrlLookup = new HashMap<>();
    private final Map<String, String> cmsUrlLookup = new HashMap<>();

    private final String cmsUrl;
    private final String siteUrl;

    public TestContentUrls(final String cmsUrl, final String siteUUrl) {
        this.cmsUrl = cmsUrl;
        this.siteUrl = siteUUrl;
        instance.set(this);
        setupSiteUrls();
        setupCmsUrls();
    }

    public static TestContentUrls instance() {
        return instance.get();
    }

    public String lookupSiteUrl(String pageName) {
        final String lowerCasedPageName = pageName.toLowerCase();

        if (!siteUrlLookup.containsKey(lowerCasedPageName)) {
            throw new RuntimeException("Unknown pageName: " + pageName);
        }

        String url = siteUrlLookup.get(lowerCasedPageName);
        if (!url.startsWith("http")) {
            url = siteUrl + url;
        } // else: URL is direct/absolute and should be returned verbatim

        return url;
    }

    public String lookupCmsUrl(String pageName) {
        final String lowerCasedPageName = pageName.toLowerCase();

        if (!cmsUrlLookup.containsKey(lowerCasedPageName)) {
            throw new RuntimeException("Unknown pageName: " + pageName);
        }

        return cmsUrl
            + "/?1&path=/content/documents/corporate-website"
            + cmsUrlLookup.get(lowerCasedPageName);
    }

    private void setupSiteUrls() {
        addSiteUrl("home", "/");

        addSiteUrl("search", "/search");

        addSiteUrl("shmi", "/shmi");

        // data sets pages
        addSiteUrl("publication with datasets",
            "/data-and-information/publications/acceptance-tests/publication-with-datasets");
        addSiteUrl("publication with datasets dataset",
            "/data-and-information/publications/acceptance-tests/publication-with-datasets/datasets-subfolder/publication-with-datasets-dataset");
        addSiteUrl("series with publication with datasets",
            "/data-and-information/publications/acceptance-tests/series-with-publication-with-datasets");

        // folder
        addSiteUrl("acceptence tests folder", "/data-and-information/publications/acceptance-tests");

        // series page
        addSiteUrl("valid publication series",
            "/data-and-information/publications/valid-publication-series");
        addSiteUrl("valid publication series direct",
            "/data-and-information/publications/valid-publication-series/content");
        addSiteUrl("valid publication series old url",
            "/publications/valid-publication-series/content");

        addSiteUrl("series without latest",
            "/data-and-information/publications/acceptance-tests/series-without-latest");

        // archive page
        addSiteUrl("valid publication archive",
            "/data-and-information/publications/acceptance-tests/valid-publication-archive");
        addSiteUrl("valid publication archive direct",
            "/data-and-information/publications/acceptance-tests/valid-publication-archive/content");

        addSiteUrl("publication with rich content",
            "/data-and-information/publications/acceptance-tests/publication-rich");

        // unpublished dataset
        addSiteUrl("upcoming publication dataset",
            "/data-and-information/publications/acceptance-tests/upcoming-publication/upcoming-dataset");

        // dataset with no parent publication
        addSiteUrl("dataset without publication",
            "/data-and-information/publications/acceptance-tests/dataset-without-publication/dataset-without-publication");

        // attachment tests
        addSiteUrl("attachment test publication",
            "/data-and-information/publications/acceptance-tests/attachment-test");
        addSiteUrl("attachment test dataset",
            "/data-and-information/publications/acceptance-tests/attachment-test/dataset");

        // coverage date test
        addSiteUrl("coverage date publication",
            "/data-and-information/publications/acceptance-tests/coveragedates-test/coverage-test");

        // bare minimum documents
        addSiteUrl("bare minimum publication",
            "/data-and-information/publications/acceptance-tests/bare-minimum-publication");
        addSiteUrl("bare minimum dataset",
            "/data-and-information/publications/acceptance-tests/bare-minimum-publication/bare-minimum-dataset");

        // invalid urls
        addSiteUrl("invalid root", "/invalid");
        addSiteUrl("invalid document", "/data-and-information/publications/invalid");
        addSiteUrl("invalid sub document", "/data-and-information/publications/acceptance-tests/invalid");

        // about pages
        addSiteUrl("terms and conditions", "/about/terms-and-conditions");

        // CI Hub/Landing
        addSiteUrl("SHMI landing", "/data-and-information/publications/ci-hub/summary-hospital-level-mortality-indicator-shmi");
        addSiteUrl("SHMI_publication_timetable.xlsx",
            S3_BUCKET_URL + "24/66E68E/SHMI_publication_timetable.xlsx");
        addSiteUrl("ci hub root", "/data-and-information/publications/ci-hub");

        // attachments
        addSiteUrl("attachment-text.pdf",
            S3_BUCKET_URL + "C0/F03E64/attachment-text.pdf");
        addSiteUrl("attachment.pdf",
            S3_BUCKET_URL + "B4/CEEAE4/attachment.pdf");

        addSiteUrl("dataset-attachment-text.pdf",
            S3_BUCKET_URL + "42/F961C2/dataset-attachment-text.pdf");
        addSiteUrl("dataset-attachment.pdf",
            S3_BUCKET_URL + "2E/636380/dataset-attachment.pdf");

        addSiteUrl("Application Guidance.docx",
            S3_BUCKET_URL + "99/225B47/Application%20Guidance.docx");
        addSiteUrl("Application Form.docx",
            S3_BUCKET_URL + "CC/0AB209/Application%20Form.docx");
        addSiteUrl("Add your indicator to the library.docx",
            S3_BUCKET_URL + "97/FEA9E2/Add%20your%20indicator%20to%20the%20library.docx");
        addSiteUrl("Request IMAS help.docx",
            S3_BUCKET_URL + "90/18350A/Request%20IMAS%20help.docx");

        // Ordered publication
        addSiteUrl("ordered publication",
            "/data-and-information/publications/acceptance-tests/ordered-publication");

        // Sectioned publication
        addSiteUrl("sectioned publication",
            "/data-and-information/publications/acceptance-tests/sectioned-publication");
        addSiteUrl("sectioned publication page robots",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[2]", "image"));
        addSiteUrl("sectioned publication page snowman",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[5]", "image"));
        addSiteUrl("sectioned publication page iphone",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[14]", "image"));
        addSiteUrl("sectioned publication page robots 2",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[15]", "image"));
        addSiteUrl("sectioned publication page business",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[16]", "image"));
        addSiteUrl("sectioned publication page computer",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[17]", "image"));
        addSiteUrl("sectioned publication page arms",
            getAttachmentUrl("sectioned-publication/first-page/first-page", "bodySections[18]", "image"));

        addSiteUrl("sectioned publication robots",
            getAttachmentUrl("sectioned-publication/content/content", "KeyFactImages", "image"));
        addSiteUrl("sectioned publication snowman",
            getAttachmentUrl("sectioned-publication/content/content", "KeyFactImages[2]", "image"));

        // Publication with National Statistic logo
        addSiteUrl("national statistic publication",
            "/data-and-information/publications/lorem-ipsum-content/morbi-tempor-euismod-vehicula");

        // Breadcrumbs
        addSiteUrl("series-publication-with-datasets Dataset",
            "/data-and-information/publications/acceptance-tests/series-with-publication-with-datasets/series-publication-with-datasets/series-publication-with-datasets-dataset");
        addSiteUrl("series publication with datasets",
            "/data-and-information/publications/acceptance-tests/series-with-publication-with-datasets/series-publication-with-datasets");
        addSiteUrl("dataset under CI folder",
            "/data-and-information/publications/clinical-indicators/ccg-outcomes-indicator-set/current/1.1-national-ccg-outcomes/ccg-dataset");
        addSiteUrl("ccg archive publication",
            "/data-and-information/publications/clinical-indicators/ccg-outcomes-indicator-set/archive/ccg-archive-document-1");

        // National Indicator Library
        addSiteUrl("NIL Hub", "/data-and-information/national-indicator-library/nihub");
        addSiteUrl("NIL Help", "/data-and-information/national-indicator-library/help");
        addSiteUrl("sample-indicator", "/data-and-information/national-indicator-library/sample-indicator");

        // Legacy publication
        addSiteUrl("legacy publication",
            "/data-and-information/publications/acceptance-tests/legacy-series/legacy-publication");
        addSiteUrl("legacy publication direct",
            "/data-and-information/publications/acceptance-tests/legacy-series/legacy-publication/content");

        addSiteUrl("service with rich content - parent",
            "/services/service-document-1/");

        addSiteUrl("homeland",
            "/homeland");

        addSiteUrl("Data and information",
            "/data-and-information");

        // Geographic coverage publications
        addSiteUrl("Geographic Coverage - Great Britain",
            "/data-and-information/publications/acceptance-tests/geographiccoverage-test/great-britain");
        addSiteUrl("Geographic Coverage - United Kingdom",
            "/data-and-information/publications/acceptance-tests/geographiccoverage-test/united-kingdom");
        addSiteUrl("Geographic Coverage - British Isles",
            "/data-and-information/publications/acceptance-tests/geographiccoverage-test/british-isles");
        addSiteUrl("Geographic Coverage - Other combination",
            "/data-and-information/publications/acceptance-tests/geographiccoverage-test/other-combination");

        // General page
        addSiteUrl("General test document",
            "/website-acceptance-tests/general-test-document");
        addSiteUrl("With Side Navigation",
            "/website-acceptance-tests/general/with-side-navigation");
        addSiteUrl("Without Side Navigation",
            "/website-acceptance-tests/general/without-side-navigation");
        addSiteUrl("Without Side Navigation & Wide",
            "/website-acceptance-tests/general/without-side-navigation--wide");

        // Service page
        addSiteUrl("Service test document",
            "/website-acceptance-tests/service-test-document");

        // Hub page
        addSiteUrl("Hub test document",
            "/website-acceptance-tests/hub-test-document");

        // Published work page
        addSiteUrl("Published Work test document",
            "/website-acceptance-tests/published-work-test-document");

        // Published work chapter page
        addSiteUrl("Published Work Chapter test document",
            "/website-acceptance-tests/published-work-chapter-1");

        // Links list page
        addSiteUrl("Links list test document",
            "/website-acceptance-tests/links-list-test-document");

        // GDPR Summary page
        addSiteUrl("GDPR Summary test document",
            "/website-acceptance-tests/gdpr-summary-test-document");

        // GDPR Transparency page
        addSiteUrl("GDPR Transparency test document",
            "/website-acceptance-tests/gdpr-transparency-test-document");

        // Visual Hub page
        addSiteUrl("Visual Hub test document",
            "/website-acceptance-tests/visual-hub-test-document");

        // Glossary page
        addSiteUrl("Glossary test document",
            "/website-acceptance-tests/glossary-test-document");

        // Blog page
        addSiteUrl("Blog test document 1",
            "/website-acceptance-tests/blog/blog-test-document-1");
        addSiteUrl("Blog test document 2",
            "/website-acceptance-tests/blog/blog-test-document-2");
        addSiteUrl("Blog test document 3",
            "/website-acceptance-tests/blog/blog-subfolder/blog-test-document-3");

        // Roadmap page
        addSiteUrl("Roadmap",
            "/website-acceptance-tests/roadmap-test-document/content");
        addSiteUrl("Roadmap item 1",
            "/website-acceptance-tests/roadmap-test-document/roadmap-item-1");
        addSiteUrl("Roadmap item 2",
            "/website-acceptance-tests/roadmap-test-document/roadmap-item-2");

        // Person
        addSiteUrl("George Lucastine",
            "/website-acceptance-tests/person-test-document");
        addSiteUrl("John Doe",
            "/website-acceptance-tests/person-test-document-2");
        addSiteUrl("Cynthia Barker",
            "/website-acceptance-tests/person-test-document-3");

        // API specifications
        addSiteUrl("Static API Catalogue",
            "/api-catalogue-preview");
        addSiteUrl("Static API Specification",
            "/website-acceptance-tests/api-specifications/static-api-specification");
    }

    private void setupCmsUrls() {
        // has to correspond to values in YAML generated by GenerateTestDocsForS3ConcurrentTest.groovy
        addCmsUrl("Legacy Publication X",
            "/publication-system/acceptance-tests/concurrent-s3-access-test/legacy-publication-");
    }

    private String getAttachmentUrl(String siteUrl, String attachmentTag, String resourceTag) {
        return "/binaries/content/documents/corporate-website/publication-system/acceptance-tests/"
            + siteUrl + "/"
            + urlEncode("publicationsystem:" + attachmentTag) + "/"
            + urlEncode("publicationsystem:" + resourceTag);
    }

    private void addSiteUrl(String pageName, String url) {
        siteUrlLookup.put(pageName.toLowerCase(), url);
    }

    private void addCmsUrl(String pageName, String url) {
        cmsUrlLookup.put(pageName.toLowerCase(), url);
    }
}
