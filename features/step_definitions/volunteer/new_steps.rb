When("I complete the volunteer form") do
  select "Animation", from: "Domaine"
  select "Fun park", from: "Secteur"
  fill_in "Remarque", with: "J'ai déjà un contact avec Alfred Dupont."
  click_button "S'inscrire"
end

Then("I should see the link to volunteer form") do
  expect(page).to have_link "M'inscrire comme bénévole"
end
