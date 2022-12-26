@javascript
Feature: Payments

  So that I can complete my order
  As a user
  I want to pay the missing amount of money

  Background:
    Given I am a confirmed user
    And I am signed in

  Scenario: I successfully pay
    Given I have an order with a pending payment
    When I visit the order summary
    And I click the link "Payer en ligne"
    Then I should see a confirmation page with the amount
    When I click the button "Payer"
    Then I should see the postfinance page
