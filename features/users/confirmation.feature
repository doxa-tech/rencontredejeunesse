Feature: Confirm account

  So that I can fully use my account
  As a newly signed up user
  I want to confirm my account

  Background:
    Given I signed up

  Scenario: I successfully confirm my account
    When "john@smith.com" open the email
    And I follow "Confirmer mon compte" in the email
    Then I should be able to sign in
    And I should be able to fully use my account

  Scenario: I don't confirm my account
    Then I should be able to sign in
    And I should not be able to fully use my account

  Scenario: I resend the confirmation email
    Given no emails have been sent
    And I am signed in
    When I request another confirmation email
    Then I should see a flash with "Email envoyé"
    And "john@smith.com" should receive an email
