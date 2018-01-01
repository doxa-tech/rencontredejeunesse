Feature: create an account

  So that I have an account
  As a visitor
  I want to create an account

  Scenario: I successfully create an account
    Given I am a visitor
    When I visit "signup/new"
    And I successfully complete the signup form
    Then I should see a flash with "Votre compte RJ Connect a été créé avec succès"
