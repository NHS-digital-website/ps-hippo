Feature: API Catalogue in Developer hub

    Scenario: Catalogue is rendered in Site
        Given I navigate to "Static API Catalogue" page
        Then I should see page titled "Test API catalogue"
        And I can see labelled element "website.linkslist.summary" with content "These are the APIs which are currently available, or in development, from NHS Digital."
        And I should see the list with title "Alphabetical navigation" containing:
            | A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z |
        And the index is rendered with entries:
            | text | href  | aria-label                                    |
            | B    | #b    | Jump to articles starting with the letter 'B' |
            | G    | #g    | Jump to articles starting with the letter 'G' |
            | N    | #n    | Jump to articles starting with the letter 'N' |
        And I can see the following links:
            | text        | href                                |
            | Bloomreach  | http://documentation.bloomreach.com |
            | Google      | http://www.google.com               |
            | NHS Digital | http://www.digital.nhs.uk           |

    Scenario: API Catalogue is available through Search
        Given I navigate to the "home" page
        When I search for "Test API catalogue"
        And I click on link "Test API catalogue"
        Then I should see page titled "Test API catalogue"
