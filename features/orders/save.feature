Feature: Save an order

  So that I can complete my order later
  As an user
  I want to save my order

  @wip
  Scenario: I save my order
    Given I am a confirmed user
    And I am signed in
    And I visit the page to order a Login entry
    When I click the link "Continuer plus tard"
    Then I should see my pending order

  Scenario: I continue my order

  Scenario: I cancel my order
