Given(/^I visit the page to order an entry$/) do
  visit new_orders_event_path(item: :rj)
end

Given(/^I am on the confirmation page for an entry$/) do
  @order = create(:order, user: @user, product_name: event.downcase.to_sym)
  visit url_for(controller: "orders/#{event.downcase}", action: "confirmation", id: @order.order_id, only_path: true)
end

When(/^I visit the order update page$/) do
  click_link "Modifier la commande"
end

When(/^I successfully update my information$/) do
  click_link "Modifier la commande"
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  check "J'ai lu les conditions générales et les accepte."
  click_button "Mettre à jour"
end

When(/^I complete the order form$/) do
  check "J'ai lu les conditions générales et les accepte."
  click_button "S'inscrire"
end

Then(/^I should see the updated information on the confirmation page$/) do
  expect(find "h2").to have_content("Récapitulatif")
  expect(find ".product-information").to have_content("Albert")
  expect(find ".product-information").to have_content("Dupont")
end

Then(/^I should see errors for the order form$/) do
  expect(page).to have_css(".error-message", text: "conditions")
end
