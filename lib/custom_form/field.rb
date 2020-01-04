
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
      content = @form.label @field.name, @field.label
      content += send(@field.field_type)
      content.html_safe
    end

    def self.display(completed_field)
      value = if completed_field.value.blank?
        "vide"
      elsif completed_field.field.select_field?
        completed_field.field.options.map { |v| v.respond_to?(:values) ? v.values : v }.flatten[completed_field.value.to_i]
      else
        completed_field.value
      end
      field = completed_field.field
      label = field.label ? field.label : I18n.t("#{I18N_PATH}.#{field.name}")
      return label, value
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
      %{<div class="select">#{@form.select @field.name, grouped_options}</div>}.html_safe
    end 

    # options = ["Autres", "Logisique" => ["Rangement", "Montage"]]
    def grouped_options
      count = -1
      @options.map do |v|
        if v.is_a? String
          count += 1
          options_for_select [[v, count]]
        elsif v.is_a? Hash
          grouped = v.map do |name, values| 
            [name, values.map { |e| count += 1; [e, count] }]
          end
          grouped_options_for_select grouped
        else
          raise ArgumentError, "Custom form: options for select are not correctly formatted."
        end
      end.join.html_safe
    end

  end