package uk.nhs.digital.apispecs.handlebars;

import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;
import static uk.nhs.digital.ExceptionUtils.wrapCheckedException;

import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * <p>
 * 'Block' type helper which, for headings present in given Markdown, invokes
 * the 'main' template block, providing it with a context object that contains the following properties:
 * <ul>
 *     <li>{@code id} - value of the {@code id} attribute of the target heading</li>
 *     <li>{@code text} - text value of the target heading</li>
 * </ul>
 * <p>
 * The original purpose of the helper is to generate hyperlinks for the side navigation panel, that would point
 * to actual headings in the corresponding sections of the content panel.
 * <p>
 * Note that only the top level of headings is taken into account and only if they are defined using the
 * <a href="https://spec.commonmark.org/0.29/#atx-headings">ATX notation</a>. The helper dynamically
 * determines which headings are of the 'top two levels'.
 * <p>
 * For example, for Markdown:
 * <pre>
 *     # Title
 *     ## Overview
 *     Some Text
 *     ## Legal use
 *     Some more text
 *     ### Some level three heading
 * </pre>
 * <p>...invocation:
 * <pre>
 *     {{#headingsHyperlinksFromMarkdown markdown}}
 *     &lt;li&gt;
 *         &lt;a href=&quot;#{{id}}&quot;&gt;{{text}}&lt;/a&gt;
 *     &lt;/li&gt;
 *     {{/headingsHyperlinksFromMarkdown}}
 * </pre>
 * <p>...will render:</p>
 * <pre>
 *     &lt;li&gt;
 *         &lt;a href=&quot;#title&quot;&gt;Title&lt;/a&gt;
 *     &lt;/li&gt;
 * </pre>
 * ...but, if heading '{@code # Title}' was to be removed from the above Markdown
 * the following would be rendered instead:
 * <pre>
 *     &lt;li&gt;
 *         &lt;a href=&quot;#overview&quot;&gt;Overview&lt;/a&gt;
 *     &lt;/li&gt;
 *     &lt;li&gt;
 *         &lt;a href=&quot;#legal-use&quot;&gt;Legal use&lt;/a&gt;
 *     &lt;/li&gt;
 *     &lt;li&gt;
 *         &lt;a href=&quot;#some-level-three-heading&quot;&gt;Some level three heading&lt;/a&gt;
 *     &lt;/li&gt;
 * </pre>
 */
public class HeadingsHyperlinksFromMarkdownHelper implements Helper<String> {

    public static final String NAME = "headingsHyperlinksFromMarkdown";

    private static final Pattern HEADING_LINE_PATTERN = Pattern.compile("^(?<hashChars>#+)\\s+(?<text>.+)$");
    private static final Pattern TRAILING_HASHES_PATTERN = Pattern.compile("^.+(?<ending>\\s#+)$");

    public static HeadingsHyperlinksFromMarkdownHelper INSTANCE = new HeadingsHyperlinksFromMarkdownHelper();


    private HeadingsHyperlinksFromMarkdownHelper() {
        // no-op; made private to promote the use of INSTANCE
    }

    @Override
    public Options.Buffer apply(final String markdown, final Options options) {

        try {
            final List<HeadingModel> headingModels = headingsModelsFrom(markdown);

            return render(headingModels, options);

        } catch (final Exception e) {
            throw new TemplateRenderingException("Failed to render hyperlinks for headings from Markdown " + markdown + ".", e);
        }
    }

    private List<HeadingModel> headingsModelsFrom(final String markdown) {

        final List<String> lines = asLines(markdown);

        return eligibleHeadingLinesFrom(lines)
            .map(this::toHeadingModel)
            .collect(toList());
    }

    private Stream<String> eligibleHeadingLinesFrom(final List<String> lines) {

        final List<String> headingLines = allHeadingLinesFrom(lines);

        if (headingLines.isEmpty()) {
            return Stream.empty();
        }

        final int topHeadingLevel = topHeadingLevelFrom(headingLines);

        final Pattern topLevelHeadingsPattern = Pattern.compile("^#{" + topHeadingLevel + "}\\s.+$");

        return headingLines.stream()
            .map(String::trim)
            .filter(line -> topLevelHeadingsPattern.matcher(line).matches())
            ;
    }

    private HeadingModel toHeadingModel(final String headingLine) {

        final String headingText = headingTextFrom(headingLine);

        return HeadingModel.with(toHeadingId(headingText), headingText);
    }

    private List<String> allHeadingLinesFrom(final List<String> lines) {
        return lines.stream()
            .map(String::trim)
            .filter(line -> HEADING_LINE_PATTERN.matcher(line).matches())
            .collect(toList());
    }

    private String headingTextFrom(final String headingLine) {

        final Matcher headingLineMatcher = HEADING_LINE_PATTERN.matcher(headingLine);
        final String textWithEnding = headingLineMatcher.find() ? headingLineMatcher.group("text") : "";
        final Matcher textWithEndingMatcher = TRAILING_HASHES_PATTERN.matcher(textWithEnding);
        final String ending = textWithEndingMatcher.find() ? textWithEndingMatcher.group("ending") : "";
        return StringUtils.removeEnd(textWithEnding, ending);
    }

    private int topHeadingLevelFrom(final List<String> headingsLines) {
        return headingsLines.stream()
            .map(HEADING_LINE_PATTERN::matcher)
            .filter(Matcher::find)
            .map(matcher -> matcher.group("hashChars"))
            .map(String::length)
            .min(Integer::compareTo)
            .orElse(0)
            ;
    }

    private List<String> asLines(final String markdown) {
        return Optional.ofNullable(markdown)
            .map(text -> text.split("\\n|\\r"))
            .map(Arrays::asList)
            .orElse(emptyList())
            ;
    }

    private String toHeadingId(final String headingText) {
        return headingText.toLowerCase().replaceAll("\\s", "-");
    }

    private Options.Buffer render(final List<HeadingModel> headingModels, final Options options) {

        final Options.Buffer buffer = options.buffer();

        headingModels.forEach(headingModel -> wrapCheckedException(
            () -> buffer.append(options.fn(headingModel))
        ));

        return buffer;
    }

    static class HeadingModel {

        private String id;
        private String text;

        private HeadingModel(final String id, final String text) {
            this.id = id;
            this.text = text;
        }

        public static HeadingModel with(final String id, final String text) {
            return new HeadingModel(id, text);
        }

        public String getId() {
            return id;
        }

        public String getText() {
            return text;
        }

        @Override public boolean equals(final Object o) {
            if (this == o) {
                return true;
            }

            if (o == null || getClass() != o.getClass()) {
                return false;
            }

            final HeadingModel headingModel = (HeadingModel) o;

            return new EqualsBuilder().append(id, headingModel.id).append(text, headingModel.text).isEquals();
        }

        @Override public int hashCode() {
            return new HashCodeBuilder(17, 37).append(id).append(text).toHashCode();
        }

        @Override public String toString() {
            return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("id", id)
                .append("text", text)
                .toString();
        }
    }
}
