Feature: Fill in a custom form

  So that I provide information for whatever reason
  As a visitor
  I want to complete a form

  Scenario: I successfully complete the form
    Given a custom form is available
    When I visit the form page
    And I complete the custom form
    Then I should see a flash with "Votre formulaire a été envoyé !"
    And "john@smith.com" should receive 1 email