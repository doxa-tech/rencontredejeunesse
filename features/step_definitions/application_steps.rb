Given(/^I am a confirmed user$/) do
  @user = create(:user)
end

Given(/^I am signed in$/) do
  visit signin_path
  fill_in "Email", with: "john@smith.com"
  fill_in "Mot de passe", with: "carottes"
  click_button "Se connecter"
end
