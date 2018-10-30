# TODO

@ignore
Feature: I sign in on the volunteer page

  So that I can fill in the form to become a volunteer
  As a visitor
  I want to sign in

  Scenario: I successfully sign in
    Given I am a confirmed user
    When I visit "/volunteers"
    And I complete the sign in form
    Then I should see a flash with "Connexion réussie"
    And I should see the volunteer form

  Scenario: I am not signed in
    When I visit "/volunteers"
    Then I should not see the volunteer form
