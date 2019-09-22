Given("a custom form is available") do
  @form = create(:form, name: "Stands", key: "stands")
  create(:field, name: "name", form: @form)
  create(:field, name: "description", form: @form)
end

When("I visit the form page") do
  visit new_form_path(key: @form.key)
end

When("I complete the custom form") do
  fill_in "Email", with: "john@smith.com"
  fill_in "Nom", with: "GBE"
  fill_in "Description", with: "Réseau de groupes bibliques étudiants"
  click_button "Enregistrer"
end