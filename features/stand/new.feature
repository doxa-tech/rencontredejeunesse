Feature: I sign up as a stand manager

  So that I can hold a stand for an event
  As an user
  I want to sign up

  Background:
    Given I am a confirmed user
    And I am signed in
    Given a stand ordering is available
    
  Scenario: I successfully order my stand
    When I visit the stand ordering page
    And I successfully submit my stand information
    Then I should see the form to order my stand
    When I successfully complete the form to order my stand
    Then I should see the confirmation page for my stand order
    And "john@smith.com" should receive an email

  Scenario: I miscomplete the stand form
    When I visit the stand ordering page
    And I click the button "Enregistrer"
    Then I should see errors for the fields "Nom"
    # And I should not see errors for the fields "Remarque"