package uk.nhs.digital.common.components.apicatalogue;

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import static java.util.stream.Collectors.toSet;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsInAnyOrder;
import static org.hamcrest.Matchers.is;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Section;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Section.section;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Subsection;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Subsection.subsection;

import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;
import org.hamcrest.Matcher;
import org.hamcrest.Matchers;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Predicate;
import java.util.stream.Stream;

@RunWith(DataProviderRunner.class)
public class FilterVisitorTest {

    private Section section;

    @Before
    public void setUp() throws Exception {
        section = model();
    }

    @Test
    public void visitsEachNodeOfTaxonomyTreeInSection() {

        // given
        final List<String> irrelevantFilteredTags = emptyList();

        final List<String> selectedTags = asList(
            "top-level-tag-with-no-descendants",
            "top-level-tag-with-descendants",
            "first-nested-tag",
            "second-nested-tag"
        );

        final FilterVisitor filterVisitor = visitorWith(irrelevantFilteredTags, selectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertVisited(section, selectedTags);
    }

    @Test
    public void setsSectionNotDisplayed_whenNoDescendantsTagIsFiltered() {

        // given
        final List<String> filteredTags = emptyList();
        final List<String> irrelevantSelectedTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(filteredTags, irrelevantSelectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertThat("Section is not displayed.",
            section.isDisplayed(),
            is(false)
        );

    }

    @Test
    @DataProvider(value = {
            "top-level-tag-with-no-descendants",
            "top-level-tag-with-descendants",
            "first-nested-tag",
            "second-nested-tag",
        }
    )
    public void setsSectionDisplayed_whenAnyDescendantTagIsFiltered(final String filteredTag) {

        // given
        final List<String> irrelevantSelectedTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(singletonList(filteredTag), irrelevantSelectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertThat("Section is displayed.", section.isDisplayed(), is(true));
    }

    @Test
    @UseDataProvider("filtersDisplayedForSelectedTags")
    public void setsSubsectionDisplayed_whenItsOrAnyDescendantsTagIsDisplayed(
        final String filteredTag,
        final List<String> expectedDisplayedSubsectionsKeys
    ) {
        // given
        final List<String> irrelevantSelectedTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(singletonList(filteredTag), irrelevantSelectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertVisibility(section, expectedDisplayedSubsectionsKeys);
    }

    @DataProvider
    @SuppressWarnings("ArraysAsListWithZeroOrOneArgument")
    public static Object[][] filtersDisplayedForSelectedTags() {
        // @formatter:off
        return new Object[][]{
            // filteredTag                          expectedDisplayedSubsectionsKeys
            {"not-matching-tag",                    emptyList()},
            {"top-level-tag-with-descendants",      asList("top-level-tag-with-descendants")},
            {"first-nested-tag",                    asList("top-level-tag-with-descendants", "first-nested-tag")},
            {"second-nested-tag",                   asList("top-level-tag-with-descendants", "second-nested-tag")},
        };
        // @formatter:on
    }

    @Test
    @UseDataProvider("filtersSelectableForFilteredTags")
    public void setsSelectableStatusOnSubsection_whenTagIsFiltered(
        final String filteredTag,
        final List<String> expectedSelectableSubsectionsKeys
    ) {
        // given
        final List<String> irrelevantSelectedTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(singletonList(filteredTag), irrelevantSelectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertSelectability(section, expectedSelectableSubsectionsKeys);
    }

    @DataProvider
    @SuppressWarnings("ArraysAsListWithZeroOrOneArgument")
    public static Object[][] filtersSelectableForFilteredTags() {
        // @formatter:off
        return new Object[][]{
            // filteredTag                          expectedSelectableSectionsKeys
            {"not-matching-tag",                    emptyList()},
            {"top-level-tag-with-descendants",      asList("top-level-tag-with-descendants")},
            {"first-nested-tag",                    asList("first-nested-tag")},
            {"second-nested-tag",                   asList("second-nested-tag")},
        };
        // @formatter:on
    }

    @Test
    @DataProvider(value = {
            "top-level-tag-with-no-descendants",
            "top-level-tag-with-descendants",
            "first-nested-tag",
            "second-nested-tag",
        }
    )
    public void setsSectionAsExpanded_whenAnyDescendantTagIsSelected(final String selectedTag) {

        // given
        final Section actualSection = model();

        final List<String> irrelevantFilteredTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(irrelevantFilteredTags, singletonList(selectedTag));

        // when
        filterVisitor.visit(actualSection);

        // then
        assertThat("Section is expanded.", actualSection.isExpanded(), is(true));
    }

    @Test
    public void setsSectionAsCollapsed_whenNoDescendantTagIsSelected() {

        // given
        final List<String> filteredTags = emptyList();
        final List<String> irrelevantSelectedTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(filteredTags, irrelevantSelectedTags);

        // when
        filterVisitor.visit(section);

        // then
        assertThat("Section is expanded.", section.isExpanded(), is(false));
    }

    @Test
    @DataProvider(value = {
            "top-level-tag-with-no-descendants",
            "top-level-tag-with-descendants",
            "first-nested-tag",
            "second-nested-tag",
        }
    )
    public void setsSelectedStatusOnSubsection_whenItsTagIsSelected(final String selectedTag) {

        // given
        final List<String> irrelevantFilteredTags = emptyList();
        final FilterVisitor filterVisitor = visitorWith(irrelevantFilteredTags, singletonList(selectedTag));

        // when
        filterVisitor.visit(section);

        // then
        assertSelected(section, singletonList(selectedTag));
    }

    private Filters.Section model() {
        return section("Section",
            subsection("Tag 1", "top-level-tag-with-no-descendants"),
            subsection("Tag 2", "top-level-tag-with-descendants",
                subsection("Tag 2.1", "first-nested-tag"),
                subsection("Tag 2.2", "second-nested-tag")
            )
        );
    }

    private void assertVisibility(final Section model, final Collection<String> expectedKeys) {
        assertSubsections(model, expectedKeys, Section::isDisplayed, "Filters with matching tags are enabled.");
    }

    private void assertSelectability(final Section model, final Collection<String> expectedKeys) {
        assertSubsections(model, expectedKeys, Subsection::isSelectable, "Filters with filtered tags are selectable.");
    }

    private void assertSelected(final Section model, final Collection<String> expectedKeys) {
        assertSubsections(model, expectedKeys, Subsection::isSelected, "Filters with selected tags are selected.");
    }

    private void assertVisited(final Section model, final Collection<String> expectedKeys) {
        assertSubsections(model, expectedKeys, Subsection::isSelected, "All subsections have been visited.");
    }

    private void assertSubsections(
        final Section section,
        final Collection<String> expectedKeys,
        final Predicate<Subsection> subsectionPredicate,
        final String assertionMessage
    ) {
        final Set<String> actualKeys = subsectionsStreamFrom(section)
            .filter(subsectionPredicate)
            .map(Subsection::getTaxonomyKey)
            .filter(expectedKeys::contains)
            .collect(toSet());

        assertThat(assertionMessage,
            actualKeys,
            containsInAnyOrder(matchersOf(expectedKeys))
        );
    }

    private FilterVisitor visitorWith(final List<String> filteredTags, final List<String> selectedTags) {
        return new FilterVisitor(new HashSet<>(filteredTags), new HashSet<>(selectedTags));
    }

    private Set<Matcher<? super String>> matchersOf(final Collection<String> expectedDisplayedSubsectionsKeys) {
        return expectedDisplayedSubsectionsKeys.stream().map(Matchers::is).collect(toSet());
    }

    private static Stream<Subsection> subsectionsStreamFrom(final Section model) {
        return model.getEntries().stream()
            .flatMap(subsection -> Stream.concat(
                Stream.of(subsection),
                subsection.getEntries().stream()
            ));
    }
}
