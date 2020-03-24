package uk.nhs.digital.common;

import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.hasEntry;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;
import static org.mockito.ArgumentMatchers.any;

import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.jackrabbit.value.DateValue;
import org.apache.jackrabbit.value.LongValue;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.*;
import java.util.stream.Collectors;
import javax.jcr.RepositoryException;
import javax.jcr.Value;

@RunWith(PowerMockRunner.class)
@PrepareForTest({OrderedSearchDateDerivedDataFunction.class})
public class OrderedSearchDateDerivedDataFunctionTest {

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd-MM-yyyy");
    private static final String ORDERED_SEARCH_DATE = "orderedSearchDate";

    private OrderedSearchDateDerivedDataFunction function = new OrderedSearchDateDerivedDataFunction();

    @Before
    public void setUp() {
        PowerMockito.mockStatic(LocalDateTime.class);
        PowerMockito.when(LocalDateTime.now(any(ZoneId.class))).thenReturn(
            ZonedDateTime.of(2010, 3, 31, 9, 20, 0, 0, ZoneId.systemDefault())
                .toLocalDateTime());
    }

    @Test
    public void upcomingDateConvertedToNegativeMillis() throws Exception {
        // given
        Map<String, Value[]> map = generateInputMap("20-03-2020");

        // when
        Map<String, Value[]> result = function.compute(map);

        // then
        long expectedValue = -parseDate("20-03-2020").getTimeInMillis();
        assertThat("Computed value is negative date millis", result, hasEntry(ORDERED_SEARCH_DATE, new Value[]{new LongValue(expectedValue)}));
    }

    @Test
    public void publishedDateConvertedToPositiveMillis() throws Exception {
        // given
        Map<String, Value[]> map = generateInputMap("10-08-2000");

        // when
        Map<String, Value[]> result = function.compute(map);

        // then
        long expectedValue = parseDate("10-08-2000").getTimeInMillis();
        assertThat("Computed value is positive date millis", result, hasEntry(ORDERED_SEARCH_DATE, new Value[]{new LongValue(expectedValue)}));
    }

    @Test
    public void documentWithoutDateDoesNotGetComputedValue() throws Exception {
        // given
        Map<String, Value[]> inputMap = generateInputMap(null);

        // then
        assertNull("With no date input you get no computed value", function.compute(inputMap).get(ORDERED_SEARCH_DATE));
    }

    @Test
    public void datesSortedByComputedValueAreOrderedAsExpected() throws Exception {
        // given
        Map<String, Map<String, Value[]>> dateToInput = new HashMap<>();
        addInput(dateToInput, "09-03-2000");
        addInput(dateToInput, "10-03-2020");
        addInput(dateToInput, "11-03-2000");
        addInput(dateToInput, "12-03-2020");
        addInput(dateToInput, "20-05-2003");
        addInput(dateToInput, "21-06-2023");

        // when
        List<String> sortedDates = dateToInput.entrySet().stream()
            .map(entry -> new MutablePair<>(entry.getKey(), computeValue(entry.getValue())))
            .sorted(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .collect(Collectors.toList());

        // We sort from highest to lowest so need to reverse
        Collections.reverse(sortedDates);

        // then
        assertThat("The order should be published first in descending order followed by upcoming in ascending date order",
            sortedDates, contains(
                "20-05-2003",
                "11-03-2000",
                "09-03-2000",
                "10-03-2020",
                "12-03-2020",
                "21-06-2023"
            ));
    }

    private void addInput(Map<String, Map<String, Value[]>> map, String date) throws ParseException {
        map.put(date, generateInputMap(date));
    }

    private long computeValue(Map<String, Value[]> input) {
        try {
            return function.compute(input).get(ORDERED_SEARCH_DATE)[0].getLong();
        } catch (RepositoryException ex) {
            throw new RuntimeException(ex);
        }
    }

    private Map<String, Value[]> generateInputMap(String dateStr) throws ParseException {
        Map<String, Value[]> map = new HashMap<>();

        if (dateStr != null) {
            map.put("date", new Value[]{new DateValue(parseDate(dateStr))});
        }
        return map;
    }

    private Calendar parseDate(String dateStr) throws ParseException {
        Calendar date = Calendar.getInstance();
        date.setTime(DATE_FORMAT.parse(dateStr));
        return date;
    }
}
