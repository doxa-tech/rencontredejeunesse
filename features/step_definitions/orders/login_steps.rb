When(/^I complete the Login form$/) do
  fill_in "Nombre d'entrées", with: "2"
  step "I complete the order form"
end

When(/^I miscomplete the Login update form$/) do
  fill_in "Nombre d'entrées", with: ""
  fill_in "Prénom", with: ""
  click_button "Mettre à jour"
end

Then(/^I should see errors for the Login form$/) do
  expect(find "#error").to have_content("Nombre d'entrées")
  step "I should see errors for the order form"
end
