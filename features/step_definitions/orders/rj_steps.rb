When(/^I complete the RJ form$/) do
  fill_in "Nombre de forfaits", with: "2"
  fill_in "Prénom", with: "John"
  fill_in "Nom de famille", with: "Smith"
  fill_in "Téléphone", with: "010010101"
  fill_in "Email", with: "john@smith.com"
  fill_in "Adresse", with: "Route de chemin 1"
  fill_in "NPA", with: "1630"
  fill_in "Ville", with: "Bulle"
  find(:select, 'Pays').first(:option, 'Suisse').select_option
  check "J'ai lu les conditions générales et tous les participants les acceptent."
  click_button "S'inscrire"
end
