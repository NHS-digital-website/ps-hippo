package uk.nhs.digital.apispecs;

import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.mock;

import org.junit.Before;
import org.junit.Test;
import uk.nhs.digital.apispecs.jcr.JcrDocumentLifecycleSupport;
import uk.nhs.digital.apispecs.model.ApiSpecificationDocument;

public class ApiSpecificationDocumentTest {

    private JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport;

    @Before
    public void setUp() {
        jcrDocumentLifecycleSupport = mock(JcrDocumentLifecycleSupport.class);
    }

    @Test
    public void setHtml_delegatesToDocumentProxy() {

        // given
        final ApiSpecificationDocument apiSpecificationDocument = ApiSpecificationDocument.from(jcrDocumentLifecycleSupport);

        final String updatedHtmlContent = "<p>updated HTML content</p>";

        // when
        apiSpecificationDocument.setHtml(updatedHtmlContent);

        // then
        then(jcrDocumentLifecycleSupport).should().setStringProperty("website:html", updatedHtmlContent);
    }

    @Test
    public void setSpecJson_delegatesToDocumentProxy() {

        // given
        final ApiSpecificationDocument apiSpecificationDocument = ApiSpecificationDocument.from(jcrDocumentLifecycleSupport);

        final String updatedSpecJsonContent = "{ \"json\": \"payload\" }";

        // when
        apiSpecificationDocument.setSpecJson(updatedSpecJsonContent);

        // then
        then(jcrDocumentLifecycleSupport).should().setStringProperty("website:json", updatedSpecJsonContent);
    }

    @Test
    public void publish_delegatesToDocumentProxy() {

        // given
        final ApiSpecificationDocument apiSpecificationDocument = ApiSpecificationDocument.from(jcrDocumentLifecycleSupport);

        // when
        apiSpecificationDocument.saveAndPublish();

        // then
        then(jcrDocumentLifecycleSupport).should().saveAndPublish();
    }
}