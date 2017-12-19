@javascript @ignore
Feature: Payment

  So that I directly pay my entry
  As a buyer
  I want to pay online with my card

  Background:
    Given I am on the confirmation page for a RJ entry
    And I confirm my order

  Scenario: I successfully complete my payment
    When I successfully pay online
    Then I should see the success page

  Scenario: I cancel the payment
    When I cancel the payment
    Then I should see the cancel page

  Scenario: The payment is uncertain
    When I make a uncertain payment
    Then I should see the uncertain page
