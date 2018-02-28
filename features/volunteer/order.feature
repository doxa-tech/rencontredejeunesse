Feature: Order as a volunteer

  So that I can take advantage of the discount
  As a volunteer
  I want to order an entry

  Background:
    Given I am a volunteer
    And I am signed in

  Scenario: I successfully order an entry
    When I visit "connect/volunteers"
    And I click the button "Commander mon entrée"
    Then I should see the volunteer confirmation page

  Scenario: I have a free entry
    When I visit "connect/volunteers"
    And I fill in a free entry discount
    And I click the button "Commander mon entrée"
    Then I should see the volunteer confirmation page
    And I should see a discount on the volunteer price
    And I should see "Finaliser ma commande"
