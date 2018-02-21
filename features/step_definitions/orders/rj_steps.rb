When(/^I complete the RJ form$/) do
  fill_in "Groupe de jeunes ou église", with: "Waykup"
  find(".participants-wrap input[type=checkbox]").set(true) # lodging
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

Then("I should see the right amount for the RJ order") do
  amount = Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE
  expect(page).to have_content "#{amount} CHF"
end
