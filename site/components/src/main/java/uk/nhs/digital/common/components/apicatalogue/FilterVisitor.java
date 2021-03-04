package uk.nhs.digital.common.components.apicatalogue;

import static uk.nhs.digital.common.components.apicatalogue.Filters.Section;
import static uk.nhs.digital.common.components.apicatalogue.Filters.Subsection;

import java.util.Set;
import java.util.function.Predicate;

public class FilterVisitor {
    private Set<String> filteredTags;
    private Set<String> selectedTags;

    public FilterVisitor(final Set<String> filteredTags, final Set<String> selectedTags) {
        this.filteredTags = filteredTags;
        this.selectedTags = selectedTags;
    }

    public void visit(final Filters filters) {
        filters.accept(this);
    }

    public void visit(final Section section) {
        section.accept(this);

        updateDisplayed(section);
        updateExpanded(section);
    }

    public void visit(final Subsection subsection) {
        subsection.accept(this);

        updateDisplayed(subsection);
        updateSelectability(subsection);
        updateSelected(subsection);
        updateExpanded(subsection);
    }

    private void updateDisplayed(final Section section) {
        if (hasDisplayedChild.test(section)) {
            section.display();
        } else {
            section.hide();
        }
    }

    private void updateDisplayed(final Subsection subsection) {
        if (hasFilteredTag.or(hasDisplayedChild).test(subsection)) {
            subsection.display();
        } else {
            subsection.hide();
        }
    }

    private void updateExpanded(final Section section) {
        if (section.getEntries().stream().anyMatch(entry -> entry.isSelected() || entry.isExpanded())) {
            section.expand();
        } else {
            section.collapse();
        }
    }

    private void updateSelected(final Subsection subsection) {
        if (hasSelectedTag.test(subsection)) {
            subsection.select();
        } else {
            subsection.deselect();
        }
    }

    private void updateSelectability(final Subsection subsection) {
        if (hasFilteredTag.test(subsection)) {
            subsection.setSelectable();
        } else {
            subsection.setUnselectable();
        }
    }

    private Predicate<Subsection> hasSelectedTag = subsection -> selectedTags.contains(subsection.getTaxonomyKey());
    private Predicate<Subsection> hasFilteredTag = subsection -> filteredTags.contains(subsection.getTaxonomyKey());
    private Predicate<Section> hasDisplayedChild = section -> section.getEntries().stream().anyMatch(Subsection::isDisplayed);
}

