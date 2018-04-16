Feature: Pay by invoice

  So that we avoid the tax on the credit card
  As an user
  He must pay by invoice

  Scenario: I successfully pay by invoice
    Given I am a confirmed user
    And I am signed in
    And I am on the confirmation page with a payment by invoice
    When I click the link "Finaliser ma commande"
    Then I should see the success page
    And "john@smith.com" should receive an email
