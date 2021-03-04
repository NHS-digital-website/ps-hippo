Feature: API Catalogue in Developer hub

    Scenario: API Catalogue renders all results when no filters applied
        Given I navigate to "Static API Catalogue" page
        Then I should see page titled "Test API catalogue"
        And I can see labelled element "website.linkslist.summary" with content "Test API catalogue for smoke tests"
        And I should see the list with title "Alphabetical navigation" containing:
            | A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z |
        And the index is rendered with entries:
            | text | href  | aria-label                                    |
            | A    | #a    | Jump to articles starting with the letter 'A' |
            | B    | #b    | Jump to articles starting with the letter 'B' |
            | E    | #e    | Jump to articles starting with the letter 'E' |
            | N    | #n    | Jump to articles starting with the letter 'N' |
        And I can see the following links:
            | text                             | href                                                           |
            | A Doc With Mapped Taxonomy Tags  | /site/developer/api-catalogue/doc-with-mapped-taxonomy-tags-a  |
            | B Doc With Mapped Taxonomy Tags  | /site/developer/api-catalogue/doc-with-mapped-taxonomy-tags-b  |
            | External Resource                | https://google.com                                             |
            | No Mapped Taxonomy Tags          | /site/developer/api-catalogue/doc-with-no-mapped-taxonomy-tags |

    Scenario: API Catalogue renders filtered results when filters applied
        Given I navigate to "Static API Catalogue" page
        When I click on the label for "toggler_services"
        And I click on the "Filter by Inpatient" button
        Then the index is rendered with entries:
            | text | href  | aria-label                                    |
            | A    | #a    | Jump to articles starting with the letter 'A' |
            | B    | #b    | Jump to articles starting with the letter 'B' |
        And I can see the following links:
            | text                             | href                                                           |
            | A Doc With Mapped Taxonomy Tags  | /site/developer/api-catalogue/doc-with-mapped-taxonomy-tags-a  |
            | B Doc With Mapped Taxonomy Tags  | /site/developer/api-catalogue/doc-with-mapped-taxonomy-tags-b  |

    Scenario: API Catalogue is available through Search
        Given I navigate to the "home" page
        When I search for "Test API catalogue"
        And I click on link "Test API catalogue"
        Then I should see page titled "Test API catalogue"
