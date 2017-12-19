Feature: Login order

  So that I can have an entry
  As a signed in user
  I want to order online

  Background:
    Given I am signed in
  @wip
  Scenario: I successfully complete the inscription form
    Given I visit the page to order a Login entry
    When I complete the Login form
    Then I should see the confirmation page
  @ignore
  Scenario: I miscomplete the inscription form
    Given I visit the page to order a Login entry
    When I miscomplete the order form
    Then I should see errors for the Login form
  @ignore
  Scenario: I successfully update my information
    Given I am on the confirmation page for a Login entry
    When I successfully update my information
    Then I should see the updated information on the confirmation page
  @ignore
  Scenario: I miscomplete the update form
    Given I am on the confirmation page for a Login entry
    When I visit the order update page
    When I miscomplete the Login update form
    Then I should see errors for the Login form
