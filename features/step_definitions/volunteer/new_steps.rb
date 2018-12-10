Given("I already signed up as a volunteer") do
  create(:option_order, order_bundle: @order_bundle, user: @user)
end

Given("I already signed up as a volunteer and I completed my order") do
  @order = create(:event_order, user: @user)
  @order.main_payment.update_attributes(status: 9)
  create(:option_order, order_bundle: @order_bundle, user: @user, order: @order)
end

When("I successfully submit my volunteering preferences") do
  select "Animation", from: "Domaine"
  select "Fun park", from: "Secteur"
  fill_in "Remarque", with: "J'ai déjà un contact avec Alfred Dupont."
  click_button "S'inscrire"
end

When("I successfully complete the form to order my volunteer pass") do
  check "J'ai lu les conditions générales et les accepte."
  click_button "Enregistrer"
end

Then("I should see the confirmation page for my volunteer order") do
  expect(page).to have_content "Récapitulatif"
  expect(page).to have_content "#{@order_bundle.items.first.price / 100 + 5} CHF"
end

Then("I should see the volunteering management page") do
  expect(page).to have_content @order_bundle.name
end

Then("I should see the form to order my volunteer pass") do
  expect(page).to have_content "Commande"
end