package uk.nhs.digital.apispecs.model;

import static org.hippoecm.repository.util.WorkflowUtils.Variant.DRAFT;
import static org.hippoecm.repository.util.WorkflowUtils.Variant.PUBLISHED;
import static uk.nhs.digital.apispecs.model.ApiSpecificationDocument.Properties.*;

import uk.nhs.digital.apispecs.jcr.JcrDocumentLifecycleSupport;

import java.time.Instant;
import java.util.Optional;

public class ApiSpecificationDocument {

    private JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport;

    private ApiSpecificationDocument(final JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport) {
        this.jcrDocumentLifecycleSupport = jcrDocumentLifecycleSupport;
    }

    public static ApiSpecificationDocument from(final JcrDocumentLifecycleSupport jcrDocumentLifecycleSupport) {
        return new ApiSpecificationDocument(jcrDocumentLifecycleSupport);
    }

    public String getId() {
        return jcrDocument().getStringProperty(SPECIFICATION_ID.jcrName(), DRAFT)
            .orElseThrow(() -> new RuntimeException("Specification id not available"))
            ;
    }

    public String getHtml() {
        Optional<String> html = jcrDocument().getStringProperty(HTML.jcrName(), PUBLISHED);
        return html.orElse("");
    }

    public void setHtml(final String html) {
        jcrDocument().setStringProperty(HTML.jcrName(), html);
    }

    public String getSpecJson() {
        Optional<String> json = jcrDocument().getStringProperty(JSON.jcrName(), PUBLISHED);
        return json.orElse("");
    }

    public void setSpecJson(final String specificationJson) {
        jcrDocument().setStringProperty(JSON.jcrName(), specificationJson);
    }

    public void save() {
        jcrDocument().save();
    }

    public void saveAndPublish() {
        jcrDocument().saveAndPublish();
    }

    @Override public String toString() {
        return "ApiSpecification{documentLifecycleSupport=" + jcrDocumentLifecycleSupport + '}';
    }

    public Optional<Instant> getLastPublicationInstant() {
        return jcrDocument().getLastPublicationInstant();
    }

    private JcrDocumentLifecycleSupport jcrDocument() {
        return jcrDocumentLifecycleSupport;
    }

    public void setLastCheckedTimestamp(final Instant instant) {
        jcrDocument().setInstantProperty(LAST_CHECKED_TIMESTAMP.jcrName, PUBLISHED, instant);
    }

    public Optional<Instant> getLastCheckedInstant() {
        return jcrDocument().getInstantProperty(LAST_CHECKED_TIMESTAMP.jcrName, PUBLISHED);
    }

    enum Properties {
        HTML("website:html"),
        JSON("website:json"),
        SPECIFICATION_ID("website:specification_id"),
        LAST_CHECKED_TIMESTAMP("website:lastCheckedTimestamp"),
        ;

        private final String jcrName;

        Properties(final String jcrName) {
            this.jcrName = jcrName;
        }

        public String jcrName() {
            return jcrName;
        }
    }
}
