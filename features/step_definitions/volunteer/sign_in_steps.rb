When("I complete the sign in form") do
  fill_in "Email", with: "john@smith.com"
  fill_in "Mot de passe", with: "carottes"
  click_button "Se connecter"
end

Then("I should see the volunteer form") do
  expect(page).to have_css("form#new_volunteer")
end

Then("I should not see the volunteer form") do
  expect(page).not_to have_css("form#new_volunteer")
end
