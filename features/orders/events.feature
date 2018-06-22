Feature: Event order

  So that I can have an entry
  As a visitor
  I want to order online

  Background:
    Given I am a confirmed user
    And I am signed in
    Given there is an event

  @wip
  Scenario: I successfully complete the inscription form
    Given I visit the page to order an entry
    When I complete the event form
    Then I should see the event order confirmation page
    And I should see the right amount for the event order

  Scenario: I miscomplete the inscription form
    Given I visit the page to order a RJ entry
    When I miscomplete the RJ form
    Then I should see errors for the RJ form

  Scenario: I successfully update my information
    Given I am on the confirmation page for a RJ entry
    When I successfully update my information
    Then I should see the updated information on the confirmation page

  Scenario: I miscomplete the update form
    Given I am on the confirmation page for a RJ entry
    When I visit the order update page
    When I miscomplete the RJ update form
    Then I should see errors for the RJ form
