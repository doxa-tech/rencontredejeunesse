
  class CustomForm::Field
    include ActionView::Helpers::FormOptionsHelper

    I18N_PATH = CustomForm::I18N_PATH
    
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

    def self.display(completed_field)
      value = if completed_field.value.blank?
        "vide"
      elsif completed_field.field.select_field?
        key = completed_field.field.options.values.flatten[value.to_i]
        I18n.t("#{I18N_PATH}.select.#{key}")
      else
        completed_field.value
      end
      return I18n.t("#{I18N_PATH}.#{completed_field.field.name}"), value
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
          I18n.t("#{I18N_PATH}.select.#{k}"), 
          v.map { |e| count += 1; [I18n.t("#{I18N_PATH}.select.#{e}"), count] }
        ]
      end
      grouped_options_for_select options
    end

  end