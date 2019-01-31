class CustomForm
  attr_reader :completed_form

  def initialize(form, url, view, attributes: {})
    @form = form
    @url = url
    @view = view
    @attributes = attributes
    @errors = []
    @fields = form.fields
  end

  def assign_attributes(attributes)
    @attributes = attributes
  end

  def valid?
    valid = true
    @fields.each do |field|
      if field.required && @attributes[field.name].blank?
        field_name = I18n.t("helpers.label.custom_form.#{field.name}")
        @errors << I18n.t("errors.messages.required", attribute: field_name)
        valid = false
      end
    end
    return valid
  end

  def save
    if valid?
      @completed_form = Form::CompletedForm.create!(form: @form)
      @fields.each do |field|
        Form::CompletedField.create!(field: field, value: @attributes[field.name], completed_form: @completed_form)
      end
      return true
    else
      return false
    end
  end

  def render
    content = "".html_safe
    @view.form_for :custom_form, url: @url, html: { id: "custom_form" } do |f|
      content += errors_tag if @errors.any?
      content += @form.fields.map do |field|
        Field.new(field, f, value: @attributes[field.name]).render
      end.join.html_safe
      content += f.submit
    end
  end

  def errors_tag
    count = @view.pluralize(@errors.count, "erreur")
    errors_wrapper(count) do
      @errors.map { |e| "<li>#{e}</li>" }.join
    end
  end

  def errors_wrapper(count)
    %{
    <div id="error">
		  <p class="title">Le formulaire contient #{count}</p>
      <ul>#{yield}</ul>
    </div>
    }.html_safe
  end

  class Field
    include ActionView::Helpers::FormOptionsHelper
    
    def initialize(field, form, value:)
      @field = field
      @form = form
      @value = value
      @options = @field.options || []
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
      @form.select @field.name, grouped_options
    end 

    def grouped_options
      count = -1
      options = @options.map do |k, v|
        [
          I18n.t("helpers.label.custom_form.select.#{k}"), 
          v.map { |e| count += 1; [I18n.t("helpers.label.custom_form.select.#{e}"), count] }
        ]
      end
      grouped_options_for_select options
    end

  end

end