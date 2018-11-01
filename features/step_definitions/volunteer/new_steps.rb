Given("I already signed up as a volunteer") do
  create(:volunteer, volunteering: @volunteering, user: @user)
end

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

Then("I should see the volunteering management page") do
  expect(page).to have_content @volunteering.name
end
