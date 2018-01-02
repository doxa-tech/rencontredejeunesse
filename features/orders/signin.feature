Feature: Sign in/Sign up

  So that I am able to order
  As a visitor
  I need to sign in or sign up

  Scenario: I successfully sign in
    Given I am a confirmed user
    When I visit "orders/login/users/new"
    And I sign in
    Then I should see the order page

  Scenario: I am not able to sign in
    Given I am a confirmed user
    When I visit "orders/login/users/new"
    And I click the button "Se connecter"
    Then I should see a flash with "Nom d'utilisateur et/ou mot de passe incorrect(s)"

  Scenario: I successfully complete the sign up form
    Given I am a visitor
    When I visit "orders/login/users/new"
    And I successfully complete the signup form
    Then I should see the order page
    And "john@smith.com" should receive an email

  Scenario: I miscomplete the sign up form
    Given I am a visitor
    When I visit "orders/login/users/new"
    And I click the button "Créer mon compte"
    Then I should see errors for the fields "Prénom, Nom de famille, Adresse"

  Scenario: I visit the order page without being signed in
    Given I am a visitor
    When I visit "orders/login/new"
    Then I should see the sign in and up page
