Given(/^I am signed in$/) do
  visit signin_path
  fill_in "Email", with: ""
  fill_in "Mot de passe", with: ""
  click_button "Se connecter"
end
