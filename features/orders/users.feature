Feature: Edit my account from the order

  So that I can easily edit my information
  As a confirmed user
  I want to edit my account from the order

  Background:
    Given I am a confirmed user
    And I am signed in
    Given I am on the confirmation page for an entry

  Scenario: I successfully update my account
    When I click the link "Editer mon compte"
    And I update my account information
    Then I should see my updated information on the confirmation page

  Scenario: I miscomplete the update form
    When I click the link "Editer mon compte"
    And I miscomplete the user update form
    Then I should see errors for the fields "Prénom"
