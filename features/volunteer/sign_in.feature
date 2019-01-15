Feature: I sign in on the volunteer page

  So that I can fill in the form to become a volunteer
  As a visitor
  I want to sign in

  Scenario: I successfully sign in
    Given I am a confirmed user
    And a volunteering is available
    When I visit "/volunteers"
    And I click the link "S'engager"
    Then I should see the sign in form
    When I complete the sign in form
    And I should see the volunteer form

  Scenario: I fill in the wrong user/password
    Given I am a confirmed user
    And a volunteering is available
    When I visit "/volunteers"
    And I click the link "S'engager"
    When I click the button "Se connecter"
    And I should see a flash with "Nom d'utilisateur et/ou mot de passe incorrect(s)"
