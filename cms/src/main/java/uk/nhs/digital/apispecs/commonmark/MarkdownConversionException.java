package uk.nhs.digital.apispecs.commonmark;

public class MarkdownConversionException extends RuntimeException {

    public MarkdownConversionException(final String message, final Exception cause) {
        super(message, cause);
    }
}
