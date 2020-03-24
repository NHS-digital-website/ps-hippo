Feature: Display of publications forming a series

    As a content consumer
    I want to be able to see a page which lists the title of all of the available publications in a publication series
    so that I can easily identify related publications.

    Scenario: List publications from the same series
        Given I navigate to the "valid publication series" page
        Then I can see "Lorem Ipsum Dolor 2014" link
        And I can see "Lorem Ipsum Dolor 2013" link
        And I can see "Lorem Ipsum Dolor 2012" link

    Scenario: Direct links to series documents
        Given I navigate to the "valid publication series direct" page
        Then I should see the page titled "Time Series Lorem Ipsum Dolor"
        And I can see "Lorem Ipsum Dolor 2014" link
        And I can see "Lorem Ipsum Dolor 2013" link
        And I can see "Lorem Ipsum Dolor 2012" link

    Scenario: Navigate from series to publication and back to series
        Given I navigate to the "valid publication series" series page
        When I click on link "Lorem Ipsum Dolor 2014"
        Then I should see publication page titled "Lorem Ipsum Dolor 2014"
        When I click on link "Time Series Lorem Ipsum Dolor"
        Then I should see series page titled "Time Series Lorem Ipsum Dolor"
        When I click on link "Lorem Ipsum Dolor 2012"
        Then I should see publication page titled "Lorem Ipsum Dolor 2012"

    Scenario: Display multiparagraph summary
        Given I navigate to "series with publication with datasets" series page
        Then I should also see multiple "Series Summary" with:
            | Integer suscipit pulvinar lacus non porta. Aenean ut tempus ex. Proin ... |
            | Pellentesque rutrum neque at felis cursus, scelerisque faucibus lacus ... |
            | Fusce sapien quam, dictum eget commodo vel, finibus condimentum ...       |

    Scenario: Series / Collection label displayed for series document type
        Given I navigate to the "valid publication series" page
        Then I should see headers:
            | Series / Collection   |
        And I should not see headers:
            | Publication           |
            | Data set              |
            | Archive               |

    Scenario: Headers for series publications
        Given I navigate to the "valid publication series" page
        Then I should see headers:
            | Latest Version    |
            | Previous Versions |
            | Upcoming          |
        When I navigate to the "series with publication with datasets" page
        Then I should see header:
            | Latest Version    |
        And I should not see header:
            | Previous Versions |
            | Upcoming          |

    Scenario: No version headers for series publications without flag
        Given I navigate to the "series without latest" page
        Then I can see "Publication 2017" link
        And I can see "Latest 2019" link
        And I should not see headers:
            | Latest Version    |
            | Previous Versions |

    Scenario: Ordering of publications by date
        When I navigate to the "valid publication series" page
        Then I should see the "Series Latest Publication" list containing:
            | 2020 - Upcoming ... |
        And I should see the "Series Previous Publications" list containing:
            | 2019 - Upcoming ... |
            | 2018 - Upcoming ... |
            | Lorem Ipsum Dolor 2014 ... |
            | Lorem Ipsum Dolor 2013 ... |
            | Lorem Ipsum Dolor 2012 ... |
        And I should see the "Series Upcoming Publications" list containing:
            | 2021 - Upcoming ... |
            | 2022 - Upcoming ... |

    Scenario: Ordering of publications by title
        When I navigate to the "series without latest" page
        Then I should see the "Series Publications" list containing:
            | 2020 Upcoming ... |
            | A publication 2018 ... |
            | Latest 2019 ...        |
            | Publication 2017 ...   |

    Scenario: List attachments and Links added to the series
        Given I navigate to the "valid publication series" page
        Then I should see "Series Resources" with:
            | Google Link                          |
            | Attachment with text\n[pdf, size: 7.2 kB] |
            | attachment.pdf\n[pdf, size: 7.2 kB]       |
