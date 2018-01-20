Feature: Save an order

  So that I can complete my order later
  As an user
  I want to save my order

  Background:
    Given I am a confirmed user
    And I am signed in

  Scenario: I save my order
    Given I visit the page to order a Login entry
    When I complete the Login form without submiting it
    And I click the button "Continuer plus tard"
    Then I should see my pending order

  Scenario: I continue my order
    Given I have a pending order
    When I visit "connect/orders/pending"
    And I click the link "Continuer"
    Then I should see the page to edit my order

  Scenario: I cancel my order
    Given I have a pending order
    When I visit "connect/orders/pending"
    And I click the link "Annuler"
    Then I should not see my pending order
