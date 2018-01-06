Feature: Edit my account from the order

  So that I can easily edit my information
  As a confirmed user
  I want to edit my account from the order

  Scenario: I successfully update my account
    Given I am a confirmed user
    And I am on the order confirmation page
    When I click the link "Editer mon compte"
    And I update my account information
    Then I should see my updated information on the confirmation page

  Scenario: I miscomplete the update form
    Given I am a confirmed user
    And I am on the order confirmation page
    When I click the link "Editer mon compte"
    And I miscomplete the user update form
    Then I should see errors for the fields "Prénom"
