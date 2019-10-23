When("I follow the link to sign up as a volunteer") do
  within("#register") do
    click_link "S'engager"
  end
end

Given("I am a volunteer") do
  @user = create(:option_order)
end

Given("a volunteering is available") do
  @form = create(:form, name: "volunteers")
  create(:field, name: "sector", required: true, field_type: "select_field", options: { sectors: ["Fun park"]}, form: @form)
  create(:field, name: "t-shirt", required: true, field_type: "text", form: @form)
  create(:field, name: "comment", required: false, field_type: "text", form: @form)
  @order_bundle = create(:order_bundle_with_items, 
                          open: false, key: "volunteers-rj-19", order_type: :event, bundle_type: :volunteer, form: @form)
end
