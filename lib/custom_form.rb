class CustomForm

  def initialize(form, url, view, attributes: {})
    @form = form
    @url = url
    @view = view
    @attributes = attributes
    @errors = []
  end

  def assign_attributes(attributes)
    @attributes = attributes
  end

  def valid?
    is_valid = true
    @form.fields.each do |field|
      if field.required && @attributes[field.name].blank?
        @errors << "Le champs #{field.name} doit être rempli"
        is_valid = false
      end
    end
    return is_valid
  end

  def save!
    completed_form = Form::CompletedForm.create!(form: @form)
    @form.fields.each do |field|
      Form::CompletedField.create!(field: field, value: @attributes[field.name], completed_form: completed_form)
    end
    return completed_form
  end

  def render
    @view.form_with scope: :custom_form, url: @url, local: true do |f|
      content = errors_tag.html_safe
      content += @form.fields.map do |field|
        Field.new(field, f, value: @attributes[field.name]).render
      end.join.html_safe
      content += f.submit "Envoyer"
    end
  end

  def errors_tag
    @errors.join
  end

  class Field
    include ActionView::Helpers::FormHelper

    def initialize(field, form, value:)
      @field = field
      @form = form
      @value = value
    end

    def render
      content = @form.label @field.name
      content += send(@field.field_type)
      return content.html_safe
    end

    private

    def text
      @form.text_field @field.name, value: @value
    end

    def number
      @form.number_field @field.name, value: @value
    end

    def email
      @form.email_field @field.name, value: @value
    end

    def select_field
      @form.select @field.name, []
    end

  end

end