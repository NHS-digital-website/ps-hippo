package uk.nhs.digital.test.util;

import uk.nhs.digital.common.util.TimeProvider;

import java.time.Instant;
import java.util.function.Supplier;

public class TimeProviderTestUtils {

    public static Instant fixNowTo(final Instant instant) {
        final Supplier<Instant> instantSupplier = () -> (instant);

        ReflectionTestUtils.setFieldOnClass(TimeProvider.class, "nowInstantSupplier", instantSupplier);

        return instant;
    }

    public static Instant fixNowTo(final String isoTime) {
        return fixNowTo(Instant.parse(isoTime));
    }
}