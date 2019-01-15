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
    And I successfully submit my volunteering preferences
    Then I should see the form to order my volunteer pass
    When I successfully complete the form to order my volunteer pass
    Then I should see the confirmation page for my volunteer order

  Scenario: I already sign up and complete my volunteer order
    Given I already signed up as a volunteer and I completed my order
    When I visit "/volunteers"
    And I click the link "S'engager"
    Then I should see the volunteering management page
    And I should see a flash with "Tu es déjà inscrit !"

  Scenario: I already signed up but I haven't completed my order
    Given I already signed up as a volunteer
    When I visit "/volunteers"
    And I click the link "S'engager"
    Then I should see the form to order my volunteer pass
    And I should see a flash with "Tu peux continuer ta commande."
