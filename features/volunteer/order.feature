Feature: Order as a volunteer

  So that I can take advantage of the discount
  As a volunteer
  I want to order an entry

  Scenario: I successfully order an entry
    Given I am a volunteer
    And I am signed in
    When I visit "connect/volunteers"
    And I click the link "Commander mon entrée"
    Then I should see the volunteer confirmation page
