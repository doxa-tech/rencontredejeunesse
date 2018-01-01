Given("I signed up") do
  step "I visit \"signup/new\""
  step "I successfully complete the signup form"
end

When("I request another confirmation email") do
  visit connect_root_path
  click_link "Renvoyer l'email de confirmation"
end

Then("I should be able to sign in") do
  step "I am signed in"
  step "I should see a flash with \"Connexion réussie\""
end

Then("I should be able to fully use my account") do
  expect(page).not_to have_content("Vous n'avez pas encore vérifié votre compte")
end

Then("I should not be able to fully use my account") do
  expect(page).to have_content("Vous n'avez pas encore vérifié votre compte")
end
