Feature: Login order

  So that I can have an entry
  As a visitor
  I want to order online

  Scenario: I successfully complete the inscription form
    Given I visit the page to order a Login entry
    When I complete the Login form
    Then I should see the confirmation page

  Scenario: I miscomplete the inscription form
    Given I visit the page to order a Login entry
    When I miscomplete the order form
    Then I should see errors for the order form

  Scenario: I successfully update my information
    Given I am on the confirmation page for a Login entry
    When I successfully update my information
    Then I should see the updated information on the confirmation page

  Scenario: I miscomplete the update form
    Given I am on the confirmation page for a Login entry
    When I miscomplete the update form
    Then I should see errors for the order form
