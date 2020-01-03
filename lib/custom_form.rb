class CustomForm
  I18N_PATH = "helpers.label.custom_form"
  TEMPLATE_PATH = File.join(Rails.root, 'lib', 'custom_form', 'template.html.erb')

  attr_reader :completed_form, :errors

  def initialize(form, url, view, attributes: {}, email: false)
    @form = form
    @url = url
    @view = view
    @attributes =  attributes
    @email = email
    @errors = []
    @fields = form.fields
    @form_fields = @fields.to_a
    if @email && @fields.none? { |f| f.name == "email"}
      @form_fields = @form_fields << Form::Field.new(name: "email", field_type: :email)
    end
  end

  def assign_attributes(attributes)
    @attributes = attributes
  end

  def valid?
    @errors = []
    @fields.each do |field|
      if field.required && @attributes[field.name].blank?
        field_name = field.label ? field.label : I18n.t("#{I18N_PATH}.#{field.name}")
        @errors << I18n.t("errors.messages.required", attribute: field_name)
      end
    end
    @errors << I18n.t("errors.messages.required", attribute: "Email") if @email && @attributes["email"].blank?
    return !@errors.any?
  end

  def save
    if valid?
      @completed_form = Form::CompletedForm.create!(form: @form)
      @fields.each do |field|
        Form::CompletedField.create!(field: field, value: @attributes[field.name], completed_form: @completed_form)
      end
      CustomFormMailer.confirmation(@attributes["email"], @completed_form).deliver_now if @email
      return true
    else
      return false
    end
  end

  def render
    return @view.form_for :custom_form, url: @url, html: { id: "custom_form" } do |form|
      content = ERB.new(File.read(TEMPLATE_PATH)).result(binding).html_safe
    end
  end

  def self.display(completed_form)
    completed_fields = completed_form.completed_fields.includes(:field)
    completed_fields.each do |field|
      label, value = Field.display(field)
      yield(label, value)
    end
  end

end