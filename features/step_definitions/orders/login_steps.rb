When(/^I complete the Login form$/) do
  fill_in "Groupe de jeunes ou église", with: "Waykup"
  step "I complete the order form"
end

When(/^I miscomplete the Login form$/) do
  fill_in "Prénom", with: ""
  click_button "S'inscrire"
end

When(/^I miscomplete the Login update form$/) do
  fill_in "Prénom", with: ""
  click_button "Mettre à jour"
end

Then(/^I should see errors for the Login form$/) do
  expect(page).to have_css(".error-message", text: "Prénom")
  step "I should see errors for the order form"
end
