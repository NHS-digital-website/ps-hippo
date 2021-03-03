package uk.nhs.digital.ps.directives;

import static java.text.MessageFormat.format;

import freemarker.core.Environment;
import freemarker.template.*;

import java.io.IOException;
import java.util.Map;

/**
 * Example usage in Freemarker template:
 * <pre>
 *
 *     <#assign truncate="uk.nhs.digital.ps.directives.TruncateFormatterDirective"?new() >
 *         ...
 *     &lt;p&gt;<@truncate text=document.someText size=300/>.&lt;/p&gt;
 * </pre>
 *
 */
public class TruncateFormatterDirective implements TemplateDirectiveModel {

    private static final String MAX_SIZE_PARAM_NAME = "size";
    private static final String INPUT_PARAM_NAME = "text";

    @Override
    public void execute(final Environment environment, final Map parameters, final TemplateModel[] loopVariables,
                        final TemplateDirectiveBody body) throws TemplateException, IOException {

        assertRequiredParameterPresent(parameters, environment, MAX_SIZE_PARAM_NAME);
        assertRequiredParameterPresent(parameters, environment, INPUT_PARAM_NAME);

        final int size = getValueAsInt(parameters, MAX_SIZE_PARAM_NAME);
        final String text = getValueAsString(parameters, INPUT_PARAM_NAME);
        final String result = truncate(text, size);

        environment.getOut().append(result);
    }

    private String truncate(String text, final int size) {
        int endIndex = Math.max(size, text.indexOf(" ", size));

        if (endIndex < text.length()) {
            return text.substring(0, endIndex) + "...";
        } else {
            return text;
        }
    }

    private int getValueAsInt(final Map parameters, final String paramName) {
        return Integer.parseInt(getValueAsString(parameters, paramName));
    }

    private String getValueAsString(final Map parameters, final String paramName) {
        return parameters.get(paramName).toString().replace("&", "&amp;");
    }

    private void assertRequiredParameterPresent(final Map parameters, final Environment environment, String parameterName) throws TemplateException {
        if (!parameters.containsKey(parameterName)) {
            throw new TemplateException(format("Required parameter ''{0}'' was not provided to template {1}.",
                parameterName, getClass().getName()), environment);
        } else if (parameters.get(parameterName) == null) {
            throw new TemplateException(format("Required parameter ''{0}'' was null in template {1}.",
                parameterName, getClass().getName()), environment);
        }
    }
}
