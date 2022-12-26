Given(/^I confirm my order$/) do
  click_button "Payer"
end

When(/^I successfully pay online$/) do
  click_link "Simuler une réussite"
end

When(/^I cancel the payment$/) do
  click_link "Simuler un échec"
  click_link "Annuler le paiement"
end

Then(/^I should see the cancel page$/) do
  expect(page).to have_content("La commande a été annulée.")
end

Then(/^I should see the success page$/) do
  expect(page).to have_content("Ta commande a bien été reçue")
end
