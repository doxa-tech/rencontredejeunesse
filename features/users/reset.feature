Feature: Reset password

  So that I can change my forgotten password
  As an user
  I want to want to reset my password

  Background:
    Given I am a confirmed user

  Scenario: I successfully request a reset
    When I visit "/users/password_resets/new"
    And I fill in and submit the form with my email
    Then I should see a flash with "Un email avec les instructions t'a été envoyé"
    And "john@smith.com" should receive an email

  Scenario: I successfully change my password
    Given I requested a reset
    When "john@smith.com" opens the email
    And I follows "Réinitialiser" in the email
    When I successfully fill in and submit the form with my new password
    Then I should see a flash with "Mot de passe changé"
    And I should be able to sign in with my new password

  Scenario: I miscomplete the form to update my password
    Given I requested a reset
    When "john@smith.com" opens the email
    And I follows "Réinitialiser" in the email
    When I miscomplete the form
    Then I should see errors for the fields "Mot de passe"

  Scenario: The link expires after 2 hours
    Given I requested a reset
    When I wait 3 hours
    And "john@smith.com" opens the email
    And I follows "Réinitialiser" in the email
    When I successfully fill in and submit the form with my new password
    Then I should see a flash with "La demande pour un nouveau mot de passe a expiré"
