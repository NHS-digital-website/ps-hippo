package uk.nhs.digital.test.util;

import org.apache.commons.lang3.RandomStringUtils;

public class RandomTestUtils {

    public static String randomString() {
        return randomString("");
    }

    public static String randomString(final String prefix) {
        return prefix + RandomStringUtils.random(10, true, true);
    }
}
