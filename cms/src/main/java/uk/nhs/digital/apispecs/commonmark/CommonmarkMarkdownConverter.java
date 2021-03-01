package uk.nhs.digital.apispecs.commonmark;

import static java.lang.Integer.MAX_VALUE;
import static java.util.Collections.singletonList;
import static org.apache.commons.lang.StringUtils.removeStart;
import static org.apache.commons.lang3.StringUtils.removeEnd;

import org.apache.commons.lang3.Validate;
import org.commonmark.Extension;
import org.commonmark.ext.gfm.tables.TablesExtension;
import org.commonmark.node.AbstractVisitor;
import org.commonmark.node.Heading;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

public class CommonmarkMarkdownConverter {

    public static final int NO_CHANGE = 0;

    private static final String NO_ID_PREFIX = "";

    /**
     * <p>
     * Renders Markdown as HTML.
     * <p>
     * Headings get '{@code id}' attributes populated with values calculated from
     * the heading's text by applying 'kebab' notation to it: lowercased,
     * with spaces replaced by '-' characters.
     * <p>
     * This enables the headings to be used as 'in page' targets for hyperlinks.
     * <p>
     * For example, heading:
     * </p>
     * <pre>
     *     ## Legal use
     * </pre>
     * <p>
     * ...will be rendered as:
     * </p>
     * <pre>
     *     &lt;h2 id=&quot;legal-use&quot;&gt;Legal use&lt;/h2&gt;
     * </pre>
     *
     * @param markdown Markdown to render as HTML.
     * @return Rendered HTML.
     */
    public String toHtml(final String markdown) {
        return toHtml(markdown, NO_ID_PREFIX, NO_CHANGE);
    }

    /**
     * <p>
     * Renders Markdown as HTML.
     * <p>
     * Headings get '{@code id}' attributes populated with values calculated from
     * the heading's text by applying 'kebab' notation to it: lowercased,
     * with spaces replaced by '-' characters.
     * <p>
     * This enables the headings to be used as 'in page' targets for hyperlinks.
     * <p>
     * Id values are prepended with provided {@code headingIdPrefix}.
     * For example, for '{@code headingIdPrefix}' given as '{@code customPrefix__}' heading:
     * </p>
     * <pre>
     *     ## Legal use
     * </pre>
     * <p>
     * ...will be rendered as:
     * </p>
     * <pre>
     *     &lt;h2 id=&quot;customPrefix__legal-use&quot;&gt;Legal use&lt;/h2&gt;
     * </pre>
     * Depending on the value of {@code topHeadingLevel}, the levels of rendered headings
     * may be shifted up or down, compared to their Markdown counterparts, to ensure that
     * the top-level headings are at the level given by the parameter.
     * <p>
     * This helps to ensure that the headings rendered from Markdown embedded in a larger
     * content with headings of its own, will fit in the 'surrounding' headings hierarchy.
     * <p>
     * When 'pushing' the headings down, it can happen that the levels of the rendered
     * heading elements will go beyond the {@code h1-h6} range mandated by HTML specification.
     * In such a case, custom CSS classes can be used to preserve some distinction of headings
     * from the surrounding text (e.g. {@code .h7, .h8}, etc.).
     * <p>
     * For example, with no id prefix given, and with {@code topHeadingLevel} set to {@code 3},
     * the following Markdown:
     * <pre>
     *     # Heading A
     *     ### Heading B
     *     ###### Heading C
     * </pre>
     * ...will be rendered as:
     * <pre>
     *     &lt;h3 id=&quot;heading-a&quot;&gt;Heading A&lt;/h3&gt;
     *     &lt;h5 id=&quot;heading-b&quot;&gt;Heading B&lt;/h5&gt;
     *     &lt;h8 id=&quot;heading-c&quot;&gt;Heading C&lt;/h8&gt;
     * </pre>
     * <p>
     * Conversely, for the same parameters, the following Markdown:
     * <pre>
     *     ### Heading A
     *     #### Heading B
     *     ###### Heading C
     * </pre>
     * ...will be rendered as:
     * <pre>
     *     &lt;h1 id=&quot;heading-a&quot;&gt;Heading A&lt;/h1&gt;
     *     &lt;h2 id=&quot;heading-b&quot;&gt;Heading B&lt;/h2&gt;
     *     &lt;h4 id=&quot;heading-c&quot;&gt;Heading C&lt;/h4&gt;
     * </pre>
     * @param markdown Markdown to render as HTML. Can be {@code null}, in which case empty string is returned.
     * @param headingIdPrefix Custom prefix to prepend the auto-generated heading '{@code id}' values with.
     *                        Optional, can be {@code null}.
     * @param topHeadingLevel The level to normalise heading levels to.
     *                        Has to be greater than or equal to zero.
     *                        Zero value means no normalisation will be attempted and the original heading levels
     *                        will be preserved.
     */
    public String toHtml(final String markdown, final String headingIdPrefix, int topHeadingLevel) {
        try {
            validateArgs(topHeadingLevel);

            return renderMarkdownAsHtml(markdown, headingIdPrefix, topHeadingLevel);
        } catch (final Exception e) {
            throw new MarkdownConversionException("Failed to convert Markdown " + markdown, e);
        }
    }

    private void validateArgs(final int topHeadingLevel) {
        Validate.inclusiveBetween(0, MAX_VALUE, topHeadingLevel,
            "Argument topHeadingLevel has to be greater than or equal to zero but was " + topHeadingLevel);
    }

    private String renderMarkdownAsHtml(final String markdown, final String headingIdPrefix, final int topHeadingLevel) {
        return Optional.ofNullable(markdown)
            .map(md -> renderMarkdownText(md, headingIdPrefix, topHeadingLevel))
            .map(this::trimSurroundingParagraphTags)
            .orElse("");
    }

    private String renderMarkdownText(final String markdown, final String headingIdPrefix, int topHeadingLevel) {

        final List<Extension> extensions = singletonList(TablesExtension.create());

        final Node document = parse(markdown, extensions);

        normalizeHeadingsLevels(document, topHeadingLevel);

        return renderMarkdownModel(document, extensions, headingIdPrefix);
    }

    private String renderMarkdownModel(final Node document, final List<Extension> extensions, final String headingIdPrefix) {

        final HtmlRenderer renderer = HtmlRenderer.builder()
            .attributeProviderFactory(context -> new CodeAttributeProvider())
            .attributeProviderFactory(context -> new HeadingAttributeProvider(headingIdPrefix))
            .attributeProviderFactory(context -> new TableSortOffAttributeProvider())
            .extensions(extensions)
            .build();

        return renderer.render(document);
    }

    private Node parse(final String markdown, final List<Extension> extensions) {

        final Parser parser = Parser.builder().extensions(extensions).build();

        return parser.parse(markdown);
    }

    private void normalizeHeadingsLevels(final Node document, final int topHeadingLevel) {

        if (topHeadingLevel != NO_CHANGE) {

            int headingsLevelsOffset = headingsLevelsOffsetFrom(document, topHeadingLevel);

            shiftHeadingsLevels(document, headingsLevelsOffset);
        }
    }

    private int headingsLevelsOffsetFrom(final Node document, final int topHeadingLevel) {

        int topHeadingLevelFound = findTopHeadingLevel(document);

        return topHeadingLevel - topHeadingLevelFound;
    }

    private int findTopHeadingLevel(final Node document) {

        final AtomicInteger topHeadingLevel = new AtomicInteger();

        final AbstractVisitor topHeadingLevelFinder = new AbstractVisitor() {

            @Override public void visit(final Heading heading) {

                if (topHeadingLevel.get() == 0 || heading.getLevel() < topHeadingLevel.get()) {
                    topHeadingLevel.set(heading.getLevel());
                }

                visitChildren(heading);
            }
        };

        document.accept(topHeadingLevelFinder);

        return topHeadingLevel.get();
    }

    private void shiftHeadingsLevels(final Node document, final int headingsLevelsOffset) {

        final AbstractVisitor headingsLevelsShifter = new AbstractVisitor() {

            @Override public void visit(final Heading heading) {

                heading.setLevel(heading.getLevel() + headingsLevelsOffset);

                visitChildren(heading);
            }
        };

        document.accept(headingsLevelsShifter);
    }

    /**
     * See comments against {@linkplain io.swagger.codegen.v3.utils.Markdown#unwrapped(String)}
     * which this method is based on.
     */
    private String trimSurroundingParagraphTags(final String html) {
        return Optional.of(html)
            .map(String::trim)
            .map(text -> removeStart(text, "<p>"))
            .map(text -> removeEnd(text, "</p>"))
            .orElse("");
    }
}
