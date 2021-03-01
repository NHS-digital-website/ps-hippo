package uk.nhs.digital.intranet.enums;

public enum SearchResultType {

    PERSON("People"),
    TASK("Tasks"),
    NEWS("News"),
    TEAM("Teams"),
    BLOG("Blogs");

    final String value;
    SearchResultType(final String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
