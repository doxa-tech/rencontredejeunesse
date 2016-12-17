Given(/^I visit the page to order a (.*?) entry$/) do |event|
  visit url_for(controller: "orders/#{event.downcase}", action: "new", only_path: true)
end

Given(/^I am on the confirmation page for a (.*?) entry$/) do |event|
  @order = create(:order, product_name: event.downcase.to_sym)
  visit url_for(controller: "orders/#{event.downcase}", action: "confirmation", id: @order.order_id, only_path: true)
end

When(/^I visit the order update page$/) do
  click_link "Changer vos informations"
end

When(/^I miscomplete the order form$/) do
  click_button "S'inscrire"
end

When(/^I successfully update my information$/) do
  click_link "Changer vos informations"
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  check "J'ai lu les conditions générales et les acceptent."
  click_button "Mettre à jour"
end

When(/^I complete the order form$/) do
  fill_in "Prénom", with: "John"
  fill_in "Nom de famille", with: "Smith"
  fill_in "Téléphone", with: "010010101"
  fill_in "Email", with: "john@smith.com"
  fill_in "Adresse", with: "Route de chemin 1"
  fill_in "NPA", with: "1630"
  fill_in "Ville", with: "Bulle"
  find(:select, 'Pays').first(:option, 'Suisse').select_option
  check "J'ai lu les conditions générales et les acceptent."
  click_button "S'inscrire"
end

Then(/^I should see the updated information on the confirmation page$/) do
  expect(find "h2").to have_content("Confirmation")
  expect(find "#summary").to have_content("Albert")
  expect(find "#summary").to have_content("Dupont")
end


Then(/^I should see errors for the order form$/) do
  expect(find "#error").to have_content("Prénom")
  expect(find "#error").to have_content("conditions")
end

Then(/^I should see the confirmation page$/) do
  expect(find "h2").to have_content("Confirmation")
  expect(find "#summary").to have_content("John")
  expect(find "#summary").to have_content("john@smith.com")
end
