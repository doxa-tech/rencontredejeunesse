When("I successfully complete the volunteer form") do
  select "Animation", from: "Domaine"
  select "Fun park", from: "Secteur"
  fill_in "Remarque", with: "J'ai déjà un contact avec Alfred Dupont."
  click_button "S'inscrire"
end

Then("I should see the volunteering confirmation page") do
  expect(page).to have_content "Récapitulatif"
  expect(page).to have_content "#{@volunteering.item.price / 100 + 5} CHF"
end
