package uk.nhs.digital.common.components.apicatalogue;

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class Filters {
    private final List<Section> sections;

    private Filters(final List<Section> sections) {
        this.sections = sections;
    }

    public List<Section> getSections() {
        return sections;
    }

    public static Filters filters(final Section... sections) {
        return new Filters(asList(sections));
    }

    public void accept(FilterVisitor visitor) {
        Optional.ofNullable(this.getSections()).ifPresent(sections -> sections.forEach(visitor::visit));
    }

    public static class Section {
        private final String displayName;
        private final List<Subsection> entries;

        private boolean expanded;
        private boolean displayed;

        private Section(final String displayName, final Subsection... subsections) {
            this.displayName = displayName;
            entries = Optional.ofNullable(subsections).map(Arrays::asList).orElse(emptyList());
        }

        public String getDisplayName() {
            return displayName;
        }

        public String getKey() {
            return from(displayName);
        }

        public boolean isExpanded() {
            return expanded;
        }

        public List<Subsection> getEntries() {
            return entries;
        }

        public static Section section(final String displayName, final Subsection... subsections) {
            return new Section(displayName, subsections);
        }

        public void accept(FilterVisitor visitor) {
            Optional.ofNullable(this.getEntries()).ifPresent(entries -> entries.forEach(visitor::visit));
        }

        public void expand() {
            this.expanded = true;
        }

        public void collapse() {
            this.expanded = false;
        }

        public boolean isDisplayed() {
            return displayed;
        }

        public void display() {
            this.displayed = true;
        }

        public void hide() {
            this.displayed = false;
        }

        private String from(final String displayName) {
            return displayName.toLowerCase().replaceAll("\\s", "-");
        }
    }

    public static class Subsection extends Section {

        private final String taxonomyKey;

        private boolean selected;
        private boolean selectable;


        private Subsection(final String displayName, final String taxonomyKey, final Subsection... subsections) {
            super(displayName, subsections);
            this.taxonomyKey = taxonomyKey;
        }

        public String getTaxonomyKey() {
            return taxonomyKey;
        }

        public boolean isSelected() {
            return selected;
        }

        public static Subsection subsection(final String displayName, final String taxonomyKey, final Subsection... subsections) {
            return new Subsection(displayName, taxonomyKey, subsections);
        }

        public static Subsection subsection(final String displayName, final Subsection... subsections) {
            return new Subsection(displayName, null, subsections);
        }

        public static Subsection subsection(final String displayName, final String taxonomyKey) {
            return new Subsection(displayName, taxonomyKey);
        }

        public void select() {
            this.selected = true;
        }

        public void deselect() {
            this.selected = false;
        }

        public boolean isSelectable() {
            return selectable;
        }

        public void setSelectable() {
            this.selectable = true;
        }

        public void setUnselectable() {
            this.selectable = false;
        }
    }

}
