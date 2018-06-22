Given("there is an event") do
  @item = create(:item)
end

When(/^I complete the event form$/) do
  within(".registrants-wrap") do
    select "Rencontre de jeunesse 2018 - WE", from: "Produit"
  end
  step "I complete the order form"
end

When(/^I miscomplete the RJ form$/) do
  fill_in "Prénom", with: ""
  click_button "S'inscrire"
end

When(/^I miscomplete the RJ update form$/) do
  fill_in "Prénom", with: ""
  click_button "Mettre à jour"
end

Then(/^I should see errors for the RJ form$/) do
  expect(page).to have_css(".error-message", text: "Prénom")
  step "I should see errors for the order form"
end

Then("I should see the right amount for the event order") do
  amount = (@item.price + 500) / 100
  expect(find ".price").to have_content "#{amount} CHF"
end

Then(/^I should see the event order confirmation page$/) do
  expect(find "h2").to have_content("Récapitulatif")
  expect(find ".user-information").to have_content("john@smith.com")
  expect(find ".registrants-information").to have_content("John")
  expect(find ".registrants-information").to have_content(@item.name)
end