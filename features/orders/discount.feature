Feature: Use a discount

  So that I can enjoy a discount on my order
  As an user
  I want to use my discount code

  Background:
    Given I am a confirmed user
    Given I am signed in

  @wip
  Scenario: I use a valid discount
    Given I visit the page to order a RJ entry
    When I fill in a valid discount
    And I complete the RJ form
    Then I should see the confirmation page
    And I should see a discount

  Scenario: I use a invalid discount
