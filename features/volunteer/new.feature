Feature: I sign up as a volunteer

  So that I can be a volunteer for an event
  As an user
  I want to sign up

  Background:
    Given I am a confirmed user
    And I am signed in
    Given a volunteering is available

  @javascript
  Scenario: I successfully sign up as a volunteer
    When I visit "/volunteers"
    And I click the link "S'engager"
    And I successfully complete the volunteer form
    Then "john@smith.com" should receive an email
    Then I should see the volunteering confirmation page

  # TODO: I use a discount in the volunteer form

  # TODO
  @ignore
  Scenario: I am not signed up as a volunteer
    When I visit "/connect/volunteers"
    And I should not see "Tu es inscrit comme bénévole."
    Then I should see the link to volunteer form
