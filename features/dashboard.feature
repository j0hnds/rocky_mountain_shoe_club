Feature: Display a dashboard for the application

  So I have a place to review show information
  Whenever we feel like it

  Background:
    Given a clean database
    And a show

  Scenario: Display a navigation bar to allow me to get around
    When I go to the home page
    Then I see the following links in the navigation bar:
    | link_name    |
    | Shows        |
    | Coordinators |
    | Venues       |
    | Exhibitors   |
    | Stores       |
    | Buyers       |
