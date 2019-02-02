require 'rails_helper'

RSpec.describe CustomForm do
  let(:form) { create(:form, name: "volunteers") }
  let(:view_context) { ActionView::Base.new }

  describe "#valid?" do

    it "should add an error if a field is required" do
      create(:field, name: "t-shirt", required: true, field_type: "text", form: form)
      create(:field, name: "comment", required: false, field_type: "text", form: form)
      custom_form = CustomForm.new(form, nil, view_context)
      custom_form.valid?
      expect(custom_form.errors.count).to eq 1
    end

    it "should return false if there is at last one error" do
      create(:field, name: "t-shirt", required: true, field_type: "text", form: form)
      custom_form = CustomForm.new(form, nil, view_context)
      expect(custom_form.valid?).to be false
    end

  end

  describe "#save" do

    it "does not save if the form is not valid" do
      create(:field, name: "t-shirt", required: true, field_type: "text", form: form)
      custom_form = CustomForm.new(form, nil, view_context)
      expect(custom_form.save).to be false
    end

    it "saves the fields to the database if the form is valid" do
      create(:field, name: "comment", required: false, field_type: "text", form: form)
      create(:field, name: "sector", required: true, field_type: "select_field", options: { sectors: ["Fun park", "Animation"]}, form: form)
      attributes = { "comment" => "Un commentaire", "sector" => "0" }
      custom_form = CustomForm.new(form, nil, view_context, attributes: attributes)
      expect(custom_form.save).to be true
      custom_form.completed_form.completed_fields.each do |field|
        expect(field.value).to eq attributes[field.field.name]
      end
    end

  end

end