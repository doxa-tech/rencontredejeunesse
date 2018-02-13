Feature: I sign up as a volunteer

  So that I can be a volunteer for an event
  As an user
  I want to sign up

  Background:
    Given I am a confirmed user
    And I am signed in

  @javascript
  Scenario: I successfully sign up as a volunteer
    When I visit "/volunteers"
    And I complete the volunteer form
    Then I should see a flash with "BIENVENUE CHEZ NOUS !"
    And I should see "Tu es inscrit comme bénévole."
    And I should see "Tu as choisi comme secteur: Fun park"
    And "john@smith.com" should receive an email

  Scenario: I am not signed up as a volunteer
    When I visit "/connect/volunteers"
    And I should not see "Tu es inscrit comme bénévole."
    Then I should see the link to volunteer form
