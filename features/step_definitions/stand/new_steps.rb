Given("a stand ordering is available") do
  @form = create(:form, name: "stands")
  create(:field, name: "name", required: true, field_type: "text", form: @form)
  @order_bundle = create(:order_bundle_with_items, 
                          open: false, key: "stands-rj-20", order_type: :regular, bundle_type: :stand, form: @form)
end

When("I visit the stand ordering page") do
  visit new_option_order_path(@order_bundle.key)
end

When("I successfully submit my stand information") do
  fill_in "Nom", with: "GBEU"
  click_button "Enregistrer"
end

Then("I should see the form to order my stand") do
  expect(page).to have_content "Commande"
end

When("I successfully complete the form to order my stand") do
  select "1", from: @order_bundle.items.first.name
  check "J'ai lu les conditions générales et les accepte."
  click_button "Enregistrer"
end

Then("I should see the confirmation page for my stand order") do
  expect(page).to have_content "Récapitulatif"
  expect(page).to have_content "#{@order_bundle.items.first.price / 100} CHF"
end
