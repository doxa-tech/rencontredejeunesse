Given("I requested a reset") do
  visit "/users/password_resets/new"
  step "I fill in and submit the form with my email"
end

When("I fill in and submit the form with my email") do
  fill_in "Email", with: "john@smith.com"
  click_button "Réinitialiser son mot de passe"
end

When("I successfully fill in and submit the form with my new password") do
  fill_in "Mot de passe", with: "tomates"
  fill_in "Confirmation", with: "tomates"
  click_button "Mettre à jour"
end

Then("I should be able to sign in with my new password") do
  visit signin_path
  fill_in "Email", with: "john@smith.com"
  fill_in "Mot de passe", with: "tomates"
  click_button "Se connecter"
  expect(find '#flash').to have_content "Connexion réussie"
end
