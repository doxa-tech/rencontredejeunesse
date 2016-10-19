Given(/^I visit the page to order a (.*?) entry$/) do |event|
  visit url_for(controller: "orders/#{event.downcase}", action: "new", only_path: true)
end

Given(/^I am on the confirmation page for a (.*?) entry$/) do |event|
  @order = create(:order, product_name: event.downcase.to_sym)
  visit url_for(controller: "orders/#{event.downcase}", action: "confirmation", id: @order.order_id, only_path: true)
end

When(/^I miscomplete the update form$/) do
  click_link "Changer vos informations"
  fill_in "Prénom", with: ""
  fill_in "Nombre de forfaits", with: ""
  click_button "Mettre à jour"
end

When(/^I miscomplete the order form$/) do
  click_button "S'inscrire"
end

When(/^I successfully update my information$/) do
  click_link "Changer vos informations"
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  check "J'ai lu les conditions générales et tous les participants les acceptent."
  click_button "Mettre à jour"
end

Then(/^I should see the updated information on the confirmation page$/) do
  expect(find "h1").to have_content("Confirmation de commande")
  expect(find "#summary").to have_content("Albert")
  expect(find "#summary").to have_content("Dupont")
end


Then(/^I should see errors for the order form$/) do
  expect(find "#error").to have_content("Prénom")
  expect(find "#error").to have_content("conditions")
  expect(find "#error").to have_content("forfaits")
end

Then(/^I should see the confirmation page$/) do
  expect(find "h1").to have_content("Confirmation de commande")
  expect(find "#summary").to have_content("John")
  expect(find "#summary").to have_content("john@smith.com")
end
