Given("there is an event") do
  @item = create(:item)
end

Given(/^I visit the page to order an entry$/) do
  visit new_orders_event_path(item: :rj)
end

Given(/^I am on the confirmation page for an entry$/) do
  @order = create(:event_order, user: @user)
  visit confirmation_orders_event_path(@order.order_id)
end

When(/^I complete the event form$/) do
  within(".registrants-wrap") do
    select "Rencontre de jeunesse 2018 - WE", from: "Produit"
  end
  step "I complete the order form"
end

When(/^I miscomplete the event form$/) do
  fill_in "Prénom", with: ""
  click_button "S'inscrire"
end

When(/^I visit the order update page$/) do
  click_link "Modifier la commande"
end

When(/^I miscomplete the event update form$/) do
  fill_in "Prénom", with: ""
  click_button "Enregistrer"
end

When(/^I successfully update my information$/) do
  click_link "Modifier la commande"
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  check "J'ai lu les conditions générales et les accepte."
  click_button "Enregistrer"
end

Then(/^I should see errors for the event form$/) do
  expect(page).to have_css(".error-message", text: "Prénom")
  step "I should see errors for the order form"
end

Then("I should see the right amount for the event order") do
  amount = (@item.price + 500) / 100
  expect(find ".price").to have_content "#{amount} CHF"
end

Then(/^I should see the event confirmation page$/) do
  expect(find "h2").to have_content("Récapitulatif")
  expect(find ".user-information").to have_content("john@smith.com")
  expect(find ".registrants-information").to have_content("John")
  expect(find ".registrants-information").to have_content(@item.name)
end

Then(/^I should see the updated information on the event confirmation page$/) do
  expect(find "h2").to have_content("Récapitulatif")
  expect(find ".registrants-information").to have_content("Albert")
  expect(find ".registrants-information").to have_content("Dupont")
end