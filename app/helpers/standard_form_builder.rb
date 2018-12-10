class StandardFormBuilder < ActionView::Helpers::FormBuilder

    def field_with_errors(type, attribute, options = {})
      field = self.send("#{type}_field", attribute, options)
      message = error_message_for(attribute)
      html_wrapper(message, field)
    end

    def checkbox_with_errors(attribute, options = {}, checked_value = "1", unchecked_value = "0")
      field = self.check_box(attribute, options, checked_value, unchecked_value)
      message = error_message_for(attribute)
      html_wrapper(message, field)
    end

    def date_select_with_errors(attribute, options = {}, html_options = {})
      field = self.date_select(attribute, options, html_options)
      message = error_message_for(attribute)
      html_wrapper(message, field)
    end

    def collection_select_with_errors(attribute, collection, value_method, text_method, options = {}, html_options = {})
      field = self.collection_select(attribute, collection, value_method, text_method, options, html_options)
      message = error_message_for(attribute.to_s.chomp("_id"))
      html_wrapper(message, field)
    end

    private

    def error_message_for(attribute)
      @object.errors.full_messages_for(attribute).join(" / ")
    end

    def html_wrapper(message, field)
      %(<div><div class="error-message">#{message}</div><div class="field">#{field}</div></div>).html_safe
    end

end
