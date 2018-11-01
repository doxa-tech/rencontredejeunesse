Feature: I sign up as a volunteer

  So that I can be a volunteer for an event
  As an user
  I want to sign up

  Background:
    Given no emails have been sent
    Given I am a confirmed user
    And I am signed in
    Given a volunteering is available

  @javascript
  Scenario: I successfully sign up as a volunteer
    When I visit "/volunteering"
    And I click the link "S'engager"
    And I successfully complete the volunteer form
    Then I should see the volunteering confirmation page

  # TODO: test that an email is sent (RSpec, because @javascript is not compatible with email spec)

  # TODO: I use a discount in the volunteer form
