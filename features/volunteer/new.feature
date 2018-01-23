Feature: I sign up as a volunteer

  So that I can be a volunteer for an event
  As an user
  I want to sign up

  Background:
    Given I am a confirmed user
    And I am signed in

  @wip
  Scenario: I successfully sign up as a volunteer
    When I visit "/volunteers"
    And I complete the volunteer form
    Then I should see a flash with "Votre inscription a été envoyé"
    And "john@smith.com" should receive an email
