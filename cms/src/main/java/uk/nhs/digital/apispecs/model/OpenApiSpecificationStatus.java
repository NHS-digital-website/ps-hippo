package uk.nhs.digital.apispecs.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import uk.nhs.digital.apispecs.OpenApiSpecificationRepository;

import java.beans.ConstructorProperties;
import java.time.Instant;
import java.util.function.Supplier;

@JsonIgnoreProperties(ignoreUnknown = true)
public class OpenApiSpecificationStatus {

    private final String id;
    private final String modified;
    private String specJson;
    private Supplier<String> remoteSpecJsonSupplier;

    @ConstructorProperties({"id", "modified"})
    public OpenApiSpecificationStatus(final String id, final String modified) {
        this.id = id;
        this.modified = modified;
    }

    public String getId() {
        return id;
    }

    public Instant getModified() {
        return Instant.parse(modified);
    }

    public void setApigeeService(final OpenApiSpecificationRepository openApiSpecificationRepository) {
        remoteSpecJsonSupplier = () -> openApiSpecificationRepository.apiSpecificationJsonForSpecId(getId());
    }

    public String getSpecJson() {

        if (specJson == null) {
            specJson = remoteSpecJsonSupplier.get();
        }

        return specJson;
    }
}
