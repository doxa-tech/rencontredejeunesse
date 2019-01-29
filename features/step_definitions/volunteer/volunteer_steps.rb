Given("I am a volunteer") do
  @user = create(:option_order)
end

Given("a volunteering is available") do
  @form = create(:form, name: "volunteers")
  create(:field, name: "sector", required: true, field_type: "select_field", form: @form)
  create(:field, name: "comment", required: false, field_type: "text", form: @form)
  @order_type = create(:order_type, name: "volunteer", supertype: create(:order_type, name: "event"), form: @form)
  @order_bundle = create(:order_bundle_with_items, open: false, key: "volunteers-rj-19", order_type: @order_type)
end
