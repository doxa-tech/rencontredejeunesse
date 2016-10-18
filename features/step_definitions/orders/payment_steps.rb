Given(/^I confirm my order$/) do
  click_button "Payer"
end

When(/^I successfully pay online$/) do
  find('input[title="PostFinance Card"]').click
  find("#btn_Accept").click
  click_button "OK"
end

When(/^I cancel the payment$/) do
  find("#ncol_cancel").click
  click_button "OK"
end

When(/^I make a uncertain payment$/) do
  find('input[title="VISA"]').click
  fill_in "Ecom_Payment_Card_Number", with: "4111116666666666"
  fill_in "Ecom_Payment_Card_Verification", with: "111"
  select "12", from: "Ecom_Payment_Card_ExpDate_Month"
  select "2041", from: "Ecom_Payment_Card_ExpDate_Year"
  click_button "Oui, je confirme mon paiement"
  click_button "OK"
end

Then(/^I should see the uncertain page$/) do
  expect(page).to have_content("Votre paiement est en attente de validation par PostFinance.")
end

Then(/^I should see the cancel page$/) do
  expect(page).to have_content("Vous avez annulé le paiement")
end

Then(/^I should see the success page$/) do
  expect(page).to have_content("Votre commande a été validée")
end
