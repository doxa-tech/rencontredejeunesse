Feature: Use a discount

  So that I can enjoy a discount on my order
  As an user
  I want to use my discount code

  Background:
    Given I am a confirmed user
    And I am signed in
    Given there is an event

  Scenario: I use a valid discount
    Given I visit the page to order an entry
    When I fill in a valid discount
    And I complete the event form
    Then I should see the event confirmation page
    And I should see a discount

  Scenario: I use a invalid discount
    Given I visit the page to order an entry
    When I fill in a invalid discount
    And I complete the event form
    Then I should see an error on the discount field

  Scenario: I have a free entry
    Given I am on the confirmation page with an amount of zero
    When I click the link "Finaliser ma commande"
    Then I should see the success page
    And "john@smith.com" should receive 2 emails
