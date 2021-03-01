package uk.nhs.digital.ps.test.acceptance.pages.site;

import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.WebElement;
import uk.nhs.digital.ps.test.acceptance.pages.PageHelper;
import uk.nhs.digital.ps.test.acceptance.pages.site.nil.IndicatorPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.ps.ArchivePageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.ps.DatasetPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.ps.PublicationPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.ps.SeriesPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.BlogPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.ContentBlockElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.GdprPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.GeneralPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.GlossaryPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.HubPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.LinksListPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.PublishedWorkPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.RoadmapItemPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.RoadmapPageElements;
import uk.nhs.digital.ps.test.acceptance.pages.site.website.ServicePageElements;
import uk.nhs.digital.ps.test.acceptance.util.TestContentUrls;
import uk.nhs.digital.ps.test.acceptance.webdriver.WebDriverProvider;

import java.util.ArrayList;
import java.util.List;

public class SitePage extends AbstractSitePage {

    private PageHelper helper;
    private TestContentUrls urlLookup;
    private List<PageElements> pagesElements;

    public SitePage(final WebDriverProvider webDriverProvider,
                    final PageHelper helper,
                    final String siteUrl,
                    final TestContentUrls testContentUrls) {
        super(webDriverProvider, siteUrl);

        this.helper = helper;
        this.pagesElements = new ArrayList<>();
        urlLookup = testContentUrls;

        // load pageElement
        pagesElements.add(new ArchivePageElements());
        pagesElements.add(new CommonPageElements());
        pagesElements.add(new PublicationPageElements());
        pagesElements.add(new SeriesPageElements());
        pagesElements.add(new DatasetPageElements());
        pagesElements.add(new IndicatorPageElements());
        pagesElements.add(new GeneralPageElements());
        pagesElements.add(new ContentBlockElements());
        pagesElements.add(new ServicePageElements());
        pagesElements.add(new RoadmapPageElements());
        pagesElements.add(new RoadmapItemPageElements());
        pagesElements.add(new HubPageElements());
        pagesElements.add(new PublishedWorkPageElements());
        pagesElements.add(new LinksListPageElements());
        pagesElements.add(new GdprPageElements());
        pagesElements.add(new GlossaryPageElements());
        pagesElements.add(new BlogPageElements());
    }

    public void openByPageName(final String pageName) {
        String lookupUrl = urlLookup.lookupSiteUrl(pageName);
        getWebDriver().get(lookupUrl);
    }

    public void clickOnElement(WebElement element) {
        element.click();
    }

    public WebElement findElementWithXPath(String xPath) {
        return helper.findElement(By.xpath(xPath));
    }

    public WebElement findElementWithTitle(String title) {
        return helper.findElement(By.xpath("//*[@title='" + title + "']"));
    }

    public WebElement findOptionalElementWithTitle(String title) {
        return helper.findOptionalElement(By.xpath("//*[@title='" + title + "']"));
    }

    public WebElement findLinkWithinUiPath(String uiPath, String linkName) {
        return helper.findOptionalElement(By.xpath("//*[@data-uipath='" + uiPath + "']"))
            .findElement(By.xpath("//a[text()='" + linkName + "']"));
    }

    public WebElement findElementWithUiPath(String uiPath) {
        return helper.findElement(By.xpath("//*[@data-uipath='" + uiPath + "']"));
    }

    public WebElement findOptionalElementWithText(String text) {
        return helper.findOptionalElement(By.xpath("//*[text()='" + text + "']"));
    }

    public WebElement findElementWithText(String text) {
        return helper.findOptionalElement(By.xpath("//*[text()='" + text + "']"));
    }

    public WebElement findCssClass(String cssClass) {
        return helper.findOptionalElement(By.xpath("//*[contains(@class, '" + cssClass + "')]"));
    }

    public String getDocumentTitle() {
        return helper.findElement(By.xpath("//*[@data-uipath='document.title']")).getText();
    }

    public String getDocumentContent() {
        return helper.findElement(By.xpath("//*[@data-uipath='ps.document.content']")).getText();
    }

    public String getArticleContentSection() {
        return helper.findElement(By.xpath("//*[@class='grid-wrapper grid-wrapper--article']")).getText();
    }

    public WebElement findPageElement(String elementName) {
        return findPageElement(elementName, 0);
    }

    public WebElement findPageElement(String elementName, int nth) {
        for (PageElements pageElements : pagesElements) {
            if (pageElements.contains(elementName)) {
                return pageElements.getElementByName(elementName, nth, helper);
            }
        }

        return null;
    }

    public WebElement findFooter() {
        return helper.findElement(By.id("footer"));
    }

    public void clickCookieAcceptButton() {
        WebElement cookieConsent = helper.findOptionalElement(By.linkText("Cookie consent"));
        if (cookieConsent != null) {
            cookieConsent.click();
        }
        WebElement cookieAcceptButton = helper.findOptionalElement(By.id("CybotCookiebotDialogBodyButtonAccept"));
        if (cookieAcceptButton != null
            && cookieAcceptButton.isDisplayed()) {
            cookieAcceptButton.click();
            waitForCookiebotDialogToBeGone();
        }
    }

    private void waitForCookiebotDialogToBeGone() {
        helper.waitUntilTrue(() -> findCookiebotDialog() == null);
    }

    private WebElement findCookiebotDialog() {
        return helper.findOptionalElement(By.xpath(".//*[@id='CybotCookiebotDialog' and contains(@style,'display: block')]"));
    }
}
