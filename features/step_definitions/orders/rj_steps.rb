When(/^I complete the RJ form$/) do
  step "I complete the order form"
end

When(/^I miscomplete the RJ update form$/) do
  within ".user-information" do
    fill_in "Prénom", with: ""
  end
  click_button "Mettre à jour"
end

Then(/^I should see errors for the RJ form$/) do
  step "I should see errors for the order form"
end
