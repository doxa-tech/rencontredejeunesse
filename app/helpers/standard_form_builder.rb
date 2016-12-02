class StandardFormBuilder < ActionView::Helpers::FormBuilder

    def text_field_with_label(attribute, options={})
      field_with_label(:text, attribute, options)
    end

    def email_field_with_label(attribute, options={})
      field_with_label(:email, attribute, options)
    end

    def number_field_with_label(attribute, options={})
      field_with_label(:number, attribute, options)
    end

    def country_select_with_label(attribute, options={})
      klass = options[:required] ? "required" : nil
      self.label(attribute, class: klass) + self.country_select(attribute, options)
    end

    def field_with_label(type, attribute, options)
      klass = options[:required] ? "required" : nil
      self.label(attribute, class: klass) + self.send("#{type}_field", attribute, options)
    end

end
