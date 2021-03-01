package uk.nhs.digital.apispecs.handlebars;

import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import org.jetbrains.annotations.NotNull;
import uk.nhs.digital.apispecs.commonmark.CommonmarkMarkdownConverter;

import java.util.Optional;

/**
 * <p>
 * 'Basic' helper which renders provided Markdown to HTML, following
 * <a href="https://github.com/commonmark/commonmark-java">CommonMark</a> specification.
 * <p>
 * Supports tables defined in the 'pipe' syntax from
 * <a href="https://help.github.com/articles/organizing-information-with-tables">GitHub Flavoured Markdown</a>.
 * Note that tables have to be preceded by a blank line (i.e. at least <em>two</em> 'new line' characters).
 * <p>
 * Supports headings defined using <a href="https://spec.commonmark.org/0.29/#atx-headings">ATX notation</a>.
 * HTML elements rendered from such headings have '{@code id}' attributes applied to make them
 * viable targets for navigation hyperlinks. Values are automatically derived from heading's text and can
 * have a custom prefix applied, given through '{@code headingIdPrefix}' parameter, which helps in ensuring
 * their uniqueness.
 * <p>
 * Also supports 'normalising' the headings hierarchy by 'shifting' the levels of heading
 * elements up or down, in order to ensure that the headings rendered for the top-level headings
 * (hierarchy-wise) are exactly at the level given by parameter '{@code levelToNormaliseHeadingsTo}'.
 * This is to allow making headings emitted from Markdown fit in the hierarchy of headings that may be
 * present in the HTML surrounding that emitted from Markdown.
 * <p>
 * For example, for the following Markdown:
 * <pre>
 *      # Heading A
 *      Text A
 *      ## Heading B
 *      Text B
 *      #### Heading B
 *      Text C
 * </pre>
 * ...invocation:
 * <pre>
 *      {{{markdown propertyWithMarkdownText headingIdPrefix="customPrefix__" levelToNormaliseHeadingsTo=3}}}
 * </pre>
 * ...will render the following HTML:
 * <pre>
 *      &lt;h3 id=&quot;customPrefix__heading-a&quot;&gt;Heading A&lt;/h3&gt;
 *      Text A
 *      &lt;h5 id=&quot;customPrefix__heading-b&quot;&gt;Heading B&lt;/h5&gt;
 *      Text B
 *      &lt;h7 id=&quot;customPrefix__heading-c&quot;&gt;Heading C&lt;/h7&gt;
 *      Text C
 * </pre>
 * <p>
 * As illustrated above, it can happen that the levels of the rendered heading elements will go beyond the
 * {@code h1-h6} range mandated by HTML specification. In such a case, custom CSS classes can be used to
 * preserve some distinction of headings from the surrounding text (e.g. {@code .h7, .h8}, etc.).
 * <p>
 * For more details on the effects of those parameters, see descriptions of public methods in
 * {@linkplain CommonmarkMarkdownConverter}.
 */
public class MarkdownHelper implements Helper<String> {

    public static final String NAME = "markdown";

    private static final String PARAM_NAME_HEADING_ID_PREFIX = "headingIdPrefix";
    private static final String PARAM_NAME_NORMALISE_HEADINGS_LEVELS = "levelToNormaliseHeadingsTo";

    private final CommonmarkMarkdownConverter commonmarkMarkdownConverter;

    public MarkdownHelper(final CommonmarkMarkdownConverter commonmarkMarkdownConverter) {
        this.commonmarkMarkdownConverter = commonmarkMarkdownConverter;
    }

    @Override
    public String apply(final String markdown, final Options options) {

        try {
            return render(
                markdown,
                headingIdPrefixFrom(options),
                levelToNormaliseHeadingsToFrom(options)
            );

        } catch (final Exception e) {
            throw new RuntimeException("Failed to render Markdown: " + markdown, e);
        }
    }

    private String headingIdPrefixFrom(final Options options) {
        return options.hash(PARAM_NAME_HEADING_ID_PREFIX);
    }

    @NotNull private Integer levelToNormaliseHeadingsToFrom(final Options options) {
        return Optional.ofNullable(options.hash(PARAM_NAME_NORMALISE_HEADINGS_LEVELS))
            .filter(Integer.class::isInstance)
            .map(Integer.class::cast)
            .orElse(0);
    }

    private String render(final String markdown, final String headingIdPrefix, final int levelToNormaliseHeadingsTo) {
        return Optional.ofNullable(markdown)
            .map(markdownToRender -> commonmarkMarkdownConverter.toHtml(markdownToRender, headingIdPrefix, levelToNormaliseHeadingsTo))
            .orElse("");
    }
}
