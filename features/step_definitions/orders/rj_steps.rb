Given(/^I visit the page to order an RJ entry$/) do
  visit new_orders_rj_path
end

Given(/^I am on the confirmation page$/) do
  @order = create(:order)
  visit confirmation_orders_rj_path(@order.order_id)
end

When(/^I complete the RJ form$/) do
  fill_in "Nombre de forfaits", with: "2"
  fill_in "Prénom", with: "John"
  fill_in "Nom de famille", with: "Smith"
  fill_in "Téléphone", with: "010010101"
  fill_in "Email", with: "john@smith.com"
  fill_in "Adresse", with: "Route de chemin 1"
  fill_in "NPA", with: "1630"
  fill_in "Ville", with: "Bulle"
  find(:select, 'Pays').first(:option, 'Suisse').select_option
  check "J'ai lu les conditions générales et tous les participants les acceptent."
  click_button "S'inscrire"
end

When(/^I miscomplete the order form$/) do
  click_button "S'inscrire"
end

When(/^I successfully update my information$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the updated information on the confirmation page$/) do
  pending # Write code here that turns the phrase above into concrete actions
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
