package uk.nhs.digital.apispecs.handlebars;

import static java.util.Arrays.asList;
import static java.util.stream.Collectors.joining;
import static java.util.stream.Collectors.toList;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertThrows;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.MockitoAnnotations.initMocks;
import static uk.nhs.digital.apispecs.handlebars.OptionsStub.TEMPLATE_CONTENT_FROM_MAIN_BLOCK;
import static uk.nhs.digital.test.util.ExceptionTestUtils.wrapCheckedException;

import com.github.jknack.handlebars.Options;
import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.function.ThrowingRunnable;
import org.junit.rules.ExpectedException;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import uk.nhs.digital.apispecs.handlebars.HeadingsHyperlinksFromMarkdownHelper.HeadingModel;

import java.io.IOException;
import java.util.List;
import java.util.stream.IntStream;

@RunWith(DataProviderRunner.class)
@SuppressWarnings("StringConcatenationInsideStringBufferAppend")
public class HeadingsHyperlinksFromMarkdownHelperTest {

    @Rule public ExpectedException expectedException = ExpectedException.none();

    @Mock Options.Buffer buffer;

    private HeadingsHyperlinksFromMarkdownHelper helper = HeadingsHyperlinksFromMarkdownHelper.INSTANCE;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    @UseDataProvider("headingsInRangeOfAtxCompliantFormats")
    public void rendersMainBlockForTopLevelOfHeadings(
        final String testCase,
        final List<Integer> givenHeadingsLevels,
        final List<Integer> expectedHeadingsLevels
    ) {

        // given
        final OptionsStub options = OptionsStub.with(buffer);

        final String markdownWithEligibleHeadings = markdownWithHeadingsAt(givenHeadingsLevels);

        final List<HeadingModel> expectedHyperlinksModels = headingsModelsWith(expectedHeadingsLevels);

        // when
        final Options.Buffer actualBuffer = helper.apply(markdownWithEligibleHeadings, options);

        // then
        assertThat("Invokes main block template with details of extracted headers for " + testCase + ".",
            options.actualMainBlockTemplateParameters(),
            is(expectedHyperlinksModels)
        );

        assertMainTemplateBlockInvokedForEachEligibleHeading(expectedHeadingsLevels);

        assertThat("Returns buffer provided by Handlebars through Options.",
            buffer,
            sameInstance(actualBuffer)
        );
    }

    @DataProvider
    public static Object[][] headingsInRangeOfAtxCompliantFormats() {
        // @formatter:off
        return new Object[][]{
            // testCase                                                     givenHeadingsLevels               expectedHeadings
            {"headings starting with level 1",                              asList( 1,  2,  3            ),   asList( 1   )},
            {"headings at the end of the normal 1-6 range",                 asList( 4,  5,  6            ),   asList( 4   )},
            {"headings outside of the normal 1-6 range",                    asList(10, 11, 12            ),   asList(10   )},
            {"headings in ascending order",                                 asList( 1,  2,  3            ),   asList( 1   )},
            {"headings in descending order",                                asList( 3,  2,  1            ),   asList( 1   )},
            {"headings with top level heading in the middle",               asList( 4,  3,  5            ),   asList( 3   )},
            {"headings that are non-consecutive",                           asList( 2,  4,  5            ),   asList( 2   )},
            {"multiple headings of the same level, top-level first",        asList( 2,  3,  4, 2, 3, 4, 5),   asList( 2, 2)},
            {"multiple headings of the same level, top-level not first",    asList( 5,  2,  4, 3, 6, 2, 4),   asList( 2, 2)}
        };
        // @formatter:on
    }

    @Test
    public void handlesRangeOfHeadingsCompliantWithAtxFormat() {
        // This test ensures that we handle various variants of Markdown headings,
        // as long as they are compliant with ATX format, as per:
        // https://spec.commonmark.org/0.29/#atx-headings

        // given
        final OptionsStub options = OptionsStub.with(buffer);

        final String markdownWithEligibleHeadings = ""
            + "## 1 not preceded by a new line character"
            + "\ntext A"
            + "\n## 2 preceded with a single new line character"
            + "\ntext B"
            + "\n\n## 3 preceded with two new line characters"
            + "\ntext C"
            + "\n##4 with no space after the hash characters"
            + "\ntext D"
            + "\n ## 5 with space before the hash characters"
            + "\ntext E"
            + "\n## 6 with no following text"
            + "\n## 7 with no preceding text"
            + "\ntext F ## not heading"
            + "\n## 8 with # characters within it"
            + "\n## 9 with # characters at the end preceded by space ###"
            + "\n## 10 with # characters at the end not preceded by space###"
            + "\n## ### 11 with value starting with # characters"
            + "\n## 12 with space characters at the end  "
            + "\n  ## 13 with leading space characters"
            ;

        // when
        final Options.Buffer actualBuffer = helper.apply(markdownWithEligibleHeadings, options);

        // then
        final List<HeadingModel> expectedHeadingModels = asList(
            HeadingModel.with("1-not-preceded-by-a-new-line-character", "1 not preceded by a new line character"),
            HeadingModel.with("2-preceded-with-a-single-new-line-character", "2 preceded with a single new line character"),
            HeadingModel.with("3-preceded-with-two-new-line-characters", "3 preceded with two new line characters"),
            HeadingModel.with("5-with-space-before-the-hash-characters", "5 with space before the hash characters"),
            HeadingModel.with("6-with-no-following-text", "6 with no following text"),
            HeadingModel.with("7-with-no-preceding-text", "7 with no preceding text"),
            HeadingModel.with("8-with-#-characters-within-it", "8 with # characters within it"),
            HeadingModel.with("9-with-#-characters-at-the-end-preceded-by-space", "9 with # characters at the end preceded by space"),
            HeadingModel.with("10-with-#-characters-at-the-end-not-preceded-by-space###", "10 with # characters at the end not preceded by space###"),
            HeadingModel.with("###-11-with-value-starting-with-#-characters", "### 11 with value starting with # characters"),
            HeadingModel.with("12-with-space-characters-at-the-end", "12 with space characters at the end"),
            HeadingModel.with("13-with-leading-space-characters", "13 with leading space characters")
        );

        assertThat("Invokes main block template with details of extracted headers.",
            options.actualMainBlockTemplateParameters(),
            is(expectedHeadingModels)
        );

        assertMainTemplateBlockInvokedForEachEligibleHeading(expectedHeadingModels);

        assertThat("Returns buffer provided by Handlebars through Options.",
            buffer,
            sameInstance(actualBuffer)
        );
    }

    @Test
    public void rendersNothing_forMarkdownWithNoHeadings() {

        // given
        final OptionsStub options = OptionsStub.with(buffer);

        final String markdownWithNoEligibleHeadings = "Some text\nin `Markdown`.";

        // when
        final Options.Buffer actualBuffer = helper.apply(markdownWithNoEligibleHeadings, options);

        // then
        verifyZeroInteractions(buffer);

        assertThat("Invokes main template block with details of extracted headers.",
            options.actualMainBlockTemplateParameters(),
            is(empty())
        );

        assertThat("Returns buffer provided by Handlebars through Options.",
            buffer,
            sameInstance(actualBuffer)
        );
    }

    @Test
    public void throwsException_onRenderingFailure() {

        // given
        final Options options = mock(Options.class);
        final RuntimeException expectedCause = new RuntimeException();
        given(options.buffer()).willThrow(expectedCause);

        final String irrelevantMarkdown = "Irrelevant `Markdown`.";

        // when
        final ThrowingRunnable action = () -> helper.apply(irrelevantMarkdown, options);

        // then
        final TemplateRenderingException actualException = assertThrows(
            TemplateRenderingException.class,
            action
        );

        assertThat(
            "Exception message provides failure's details.",
            actualException.getMessage(),
            is("Failed to render hyperlinks for headings from Markdown " + irrelevantMarkdown + ".")
        );

        assertThat(
            "Cause exception is included.",
            actualException.getCause(),
            sameInstance(expectedCause)
        );
    }

    private List<HeadingModel> headingsModelsWith(final List<Integer> headingsLevels) {
        // for levels 1, 2, 3, generates models with:
        // id=heading-1, text=Heading 1
        // id=heading-2, text=Heading 2
        // id=heading-3, text=Heading 3

        return headingsLevels.stream()
            .map(headingLevel -> HeadingModel.with("heading-" + headingLevel, "Heading " + headingLevel))
            .collect(toList());
    }

    private String markdownWithHeadingsAt(final List<Integer> headingsLevels) {

        // for levels 1, 2, 3, generates Markdown:
        // # Heading 1\n
        // ## Heading 2\n
        // ### Heading 3

        return headingsLevels.stream()
            .map(headingLevel -> IntStream.rangeClosed(1, headingLevel)
                .mapToObj(level -> "#")
                .collect(joining("", "", " Heading " + headingLevel)))
            .collect(joining("\n"));
    }

    private void assertMainTemplateBlockInvokedForEachEligibleHeading(final List<?> eligibleHeadings) {
        IntStream.rangeClosed(1, eligibleHeadings.size()).forEach(level ->
            wrapCheckedException(() -> then(buffer).should().append(TEMPLATE_CONTENT_FROM_MAIN_BLOCK + "_" + level))
        );
    }
}