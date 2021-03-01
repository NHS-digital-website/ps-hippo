package uk.nhs.digital.apispecs.handlebars;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static uk.nhs.digital.test.util.FileUtils.contentOfFileFromClasspath;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.codegen.v3.templates.HandlebarTemplateEngine;
import org.junit.Test;
import uk.nhs.digital.apispecs.swagger.ApiSpecificationStaticHtml2Codegen;
import uk.nhs.digital.apispecs.swagger.model.BodyWithMediaTypeObjects;
import uk.nhs.digital.apispecs.swagger.model.BodyWithMediaTypesExtractor;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class BodyRenderingTest {

    private static final ObjectMapper OBJECT_MAPPER = BodyWithMediaTypesExtractor.OBJECT_MAPPER;

    @Test
    public void rendersExampleSpecifiedOnMediaTypeObject_evenWhenExampleIsSpecifiedOnSchema() throws IOException {

        // given
        final String bodyJson = fromFile("exampleOnMediaTypeObjectAndOnSchema.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders example from MediaTypeObject's 'example' field.",
            actualHtml,
            containsString("simple example specified in MediaTypeObject's definition")
        );
        assertThat("Does not render example from MediaTypeObject's Schema.",
            actualHtml,
            not(containsString("example specified in MediaTypeObject's schema"))
        );
    }

    @Test
    public void rendersExamplesSpecifiedOnMediaTypeObject_evenWhenExampleIsSpecifiedOnSchema() throws IOException {

        // given
        final String bodyJson = fromFile("examplesOnMediaTypeObjectAndOnSchema.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders examples from MediaTypeObject's 'examples' field.",
            actualHtml,
            allOf(
                containsString("first example from request MediaTypeObject's definition"),
                containsString("second example from request MediaTypeObject's definition")
            )
        );
        assertThat("Does not render example from MediaTypeObject's Schema.",
            actualHtml,
            not(containsString("example specified in MediaTypeObject's schema"))
        );
    }

    @Test
    public void rendersExampleSpecifiedOnSchema_whenThereIsNoExampleOnMediaTypeObject() throws IOException {

        // given
        final String bodyJson = fromFile("exampleOnSchemaNoneOnMediaTypeObject.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders example from MediaTypeObject's Schema.",
            actualHtml,
            containsString("example specified in MediaTypeObject's schema")
        );
    }

    @Test
    public void rendersExamplesHeader_whenMultipleExamplesSpecifiedInExamplesFieldOnMediaTypeObject() throws IOException {

        // given
        final String bodyJson = fromFile("multipleExamplesInCollectionOnMediaTypeObject.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders plural version of the header for multiple examples in the collection.",
            actualHtml,
            containsString(">Examples<")
        );
    }

    @Test
    public void rendersExampleHeader_whenSingleExampleSpecifiedInExamplesFieldOnMediaTypeObject() throws IOException {

        // given
        final String bodyJson = fromFile("singleExampleInCollectionOnMediaTypeObject.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders singular version of the header for single examples in the collection.",
            actualHtml,
            containsString(">Example<")
        );
    }

    @Test
    public void rendersCompleteExampleObject_withAllComponentsAndInTheRightOrder() throws IOException {
        // Other test cases verify variants of individual aspects of examples' rendering.
        // This test verifies that all components of an individual Example Object are rendered.

        // given
        final String bodyJson = fromFile("bodyWithMediaTypeObjectWithExampleObject.json");
        final String expectedHtml = fromFile("bodyWithMediaTypeObjectWithExampleObject.html");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        // Here we only care that Markdown-to-HTML conversion is applied here at all,
        // choosing backticks-to-<code> as an indicator that this happens.
        // A separate test, dedicated to the converter itself provides a more complete coverage.
        assertThat("Renders complete body with all components and in the right order.",
            actualHtml,
            is(expectedHtml)
        );
    }

    @Test
    public void rendersCompleteContentTypeSections_withAllComponentsInTheRightOrder() throws IOException {
        // Other test cases verify small, focused features in isolation.
        // This is a higher-level test, to verify that all components come together and that correct overall
        // HTML structure is rendered, as the other test cases tend to check for 'marker' texts rather than HTML
        // elements.
        //
        // Note that we don't need to model all minute edge cases here - this is what the other test methods/cases
        // are for.

        // given
        final String bodyJson = fromFile("completeBodyWithMultipleMediaTypeObjects.json");
        final String expectedHtml = fromFile("completeBodyWithMultipleMediaTypeObjects.html");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Renders complete body with all components and in the right order.",
            actualHtml,
            is(expectedHtml)
        );
    }

    @Test
    public void displaySchemaHeaderAndSectionWhenMediaTypesSchemaIsPresent() throws IOException {

        // given
        final String bodyJson = fromFile("exampleOnSchemaNoneOnMediaTypeObject.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Does not render example from MediaTypeObject's Schema.",
            actualHtml,
            (containsString("example specified in MediaTypeObject's schema"))
        );

    }

    @Test
    public void doesNotDisplaySchemaHeaderAndSectionWhenMediaTypesSchemaIsAbsent() throws IOException {

        // given
        final String bodyJson = fromFile("exampleOnMediaTypeObjectNoneOnSchema.json");

        // when
        final String actualHtml = renderFor(bodyJson);

        // then
        assertThat("Does not render example from MediaTypeObject's Schema.",
            actualHtml,
            not(containsString("example specified in MediaTypeObject's schema"))
        );

    }

    private String renderFor(final String parameterjsonDefinition) throws IOException {

        final BodyWithMediaTypeObjects bodyWithMediaTypeObjects =
            fromJson(parameterjsonDefinition, BodyWithMediaTypeObjects.class);

        final Map<String, Object> model = new HashMap<>();
        model.put("mediaTypes", bodyWithMediaTypeObjects.getMediaTypes());

        final ApiSpecificationStaticHtml2Codegen config = new ApiSpecificationStaticHtml2Codegen();

        final String templateDir = "api-specification/codegen-templates";

        config.setTemplateDir(templateDir);

        final HandlebarTemplateEngine handlebars = new HandlebarTemplateEngine(config);

        final String templateFileName = "body_param.mustache";

        return handlebars.getRendered(templateDir + "/" + templateFileName, model);
    }

    private <T> T fromJson(final String parameterJsonDefinition, final Class<T> valueType) {

        try {
            return OBJECT_MAPPER.readValue(parameterJsonDefinition, valueType);
        } catch (final JsonProcessingException e) {
            throw new RuntimeException("Failed to create test data objects from JSON.", e);
        }
    }

    private String fromFile(final String testFileName) {
        return contentOfFileFromClasspath("/test-data/api-specifications/BodyRenderingTest/" + testFileName);
    }
}
