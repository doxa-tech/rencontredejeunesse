When("I update my account information") do
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  click_button "Enregistrer"
end

When("I miscomplete the user update form") do
  fill_in "Prénom", with: ""
  click_button "Enregistrer"
end

Then("I should see my updated information on the confirmation page") do
  expect(find ".user-information").to have_content ("Albert")
  expect(find ".user-information").to have_content ("Dupont")
end
