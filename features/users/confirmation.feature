Feature: Confirm account

  So that I can fully use my account
  As a newly signed up user
  I want to confirm my account

  Scenario: I successfully confirm my account
    Given I signed up
    When I click the link in the confirmation email
    Then I should be able to sign in
    And I should be able to fully use my account
