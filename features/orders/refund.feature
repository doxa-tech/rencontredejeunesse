@ignore
Feature: Refund

  So that my ticket can be refunded
  As a buyer
  I want to make a request

  Background: 
    Given I am a confirmed user
    And I am signed in
    Given I made an order

  Scenario: I successfully complete the refund request
    When I visit "/connect"
    And I fill in the refund form
    Then I should see a flash with "Votre demande a été enregistrée"
    And "john@smith.com" should receive 1 email

  Scenario: I miscomplete the refund request
    When I visit "/connect"
    And I miscomplete the form
    Then I should see errors for the fields "Type de remboursement"