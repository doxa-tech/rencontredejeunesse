Feature: I sign in on the volunteer page

  So that I can fill in the form to become a volunteer
  As a visitor
  I want to sign in

  Scenario: I successfully sign in
    Given I am a confirmed user
    And a volunteering is available
    When I visit "/volunteering"
    And I click the link "S'engager"
    Then I should see the sign in form
    When I complete the sign in form
    And I should see the volunteer form
