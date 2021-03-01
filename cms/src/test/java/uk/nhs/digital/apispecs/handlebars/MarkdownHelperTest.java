package uk.nhs.digital.apispecs.handlebars;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.sameInstance;
import static org.junit.Assert.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static uk.nhs.digital.test.util.RandomTestUtils.randomString;

import com.github.jknack.handlebars.Options;
import org.junit.Test;
import org.junit.function.ThrowingRunnable;
import uk.nhs.digital.apispecs.commonmark.CommonmarkMarkdownConverter;

public class MarkdownHelperTest {

    private CommonmarkMarkdownConverter commonmarkMarkdownConverter = mock(CommonmarkMarkdownConverter.class);

    private final MarkdownHelper markdownHelper
        = new MarkdownHelper(commonmarkMarkdownConverter);

    @Test
    public void delegatesToCommonMarkRenderer_withNoCustomParametersSpecified() {

        // given
        final String markdownToRender = randomString("markdownToRender_");
        final String expectedRenderedValue = randomString("renderedOutput_");

        given(commonmarkMarkdownConverter.toHtml(eq(markdownToRender), isNull(), eq(0)))
            .willReturn(expectedRenderedValue);

        final OptionsStub options = OptionsStub.with(OptionsStub.Hash.empty());

        // when
        final Object actualRenderedValue = markdownHelper.apply(
            markdownToRender,
            options
        );

        // then
        assertThat("Returns value received from the actual renderer.",
            actualRenderedValue,
            sameInstance(expectedRenderedValue)
        );
    }

    @Test
    public void delegatesToCommonMarkRenderer_applyingHeadingIdPrefix() {

        // given
        final String markdownToRender = randomString("markdownToRender_");
        final String expectedRenderedValue = randomString("renderedOutput_");

        final String customHeadingIdPrefix = "customPrefix__";
        final String parameterNameHeadingIdPrefix = "headingIdPrefix";

        given(commonmarkMarkdownConverter.toHtml(markdownToRender, customHeadingIdPrefix, 0))
            .willReturn(expectedRenderedValue);

        final OptionsStub options = OptionsStub.with(
            OptionsStub.Hash.of(parameterNameHeadingIdPrefix, customHeadingIdPrefix)
        );

        // when
        final Object actualRenderedValue = markdownHelper.apply(
            markdownToRender,
            options
        );

        // then
        assertThat("Returns value received from the actual renderer.",
            actualRenderedValue,
            sameInstance(expectedRenderedValue)
        );
    }

    @Test
    public void throwsException_onMarkdownRenderingFailure() {

        // given
        final RuntimeException expectedCause = new RuntimeException();

        given(commonmarkMarkdownConverter.toHtml(any(), any(), any(Integer.class)))
            .willThrow(expectedCause);

        final Options options = OptionsStub.empty();

        final String markdown = "some markdown";

        // when
        final ThrowingRunnable action = () -> markdownHelper.apply(markdown, options);

        // then
        final RuntimeException actualException = assertThrows(
            RuntimeException.class,
            action
        );

        assertThat(
            "Exception message provides failure's details.",
            actualException.getMessage(),
            is("Failed to render Markdown: " + markdown)
        );

        assertThat(
            "Cause exception is included.",
            actualException.getCause(),
            sameInstance(expectedCause)
        );
    }
}