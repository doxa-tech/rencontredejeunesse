Given("I already signed up as a volunteer") do
  visit new_option_order_path(key: @order_bundle.key)
  step "I successfully submit my volunteering preferences"
end

Given("I already signed up as a volunteer and I completed my order") do
  visit new_option_order_path(key: @order_bundle.key)
  step "I successfully submit my volunteering preferences"
  @order = Order.last
  create(:payment, order: @order, amount: @order.amount, state: :fulfill)
end

When("I successfully submit my volunteering preferences") do
  select "Fun park", from: "Choisir un secteur"
  fill_in "T-shirt", with: "XS"
  fill_in "Remarque ou personne de contact", with: "J'ai déjà un contact avec Alfred Dupont."
  click_button "Enregistrer"
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