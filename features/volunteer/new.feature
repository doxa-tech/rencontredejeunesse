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
    When I visit "/volunteering"
    And I click the link "S'engager"
    And I successfully complete the volunteer form
    Then I should see the volunteering confirmation page

  Scenario: I already sign up and complete my volunteer order
    Given I already signed up as a volunteer
    When I visit "/volunteering"
    And I click the link "S'engager"
    Then I should see the volunteering management page
    And I should see a flash with "Tu es déjà inscrit comme bénévole."

  Scenario: I already signed up but I haven't completed my order

  # TODO: I use a discount in the volunteer form
