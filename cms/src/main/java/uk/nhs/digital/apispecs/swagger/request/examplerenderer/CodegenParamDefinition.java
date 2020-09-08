package uk.nhs.digital.apispecs.swagger.request.examplerenderer;

import static java.util.Collections.emptyMap;
import static java.util.Collections.unmodifiableMap;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Map;
import java.util.Optional;

/**
 * DTO representing CodegenParameter (request parameters) and CodegenProperty (response headers); populated by
 * deserializing CodegenParameter.jsonSchema and CodegenProperty.jsonSchema.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
class CodegenParamDefinition {

    // subset of:
    // https://swagger.io/specification/#parameter-object
    // https://swagger.io/specification/#header-object

    private String example;
    private Map<String, ParamExample> examples;

    private CodegenParamSchema schema;

    public Optional<String> getExample() {
        return Optional.ofNullable(example);
    }

    public Map<String, ParamExample> getExamples() {
        return examples == null ? emptyMap() : unmodifiableMap(examples);
    }

    public Optional<CodegenParamSchema> getSchema() {
        return Optional.ofNullable(schema);
    }
}
