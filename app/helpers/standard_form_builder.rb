class StandardFormBuilder < ActionView::Helpers::FormBuilder

    def field_with_errors(type, attribute, options = {})
      field = self.send("#{type}_field", attribute, options)
      message = error_message_for(attribute)
      html_wrapper(message, field)
    end

    def checkbox_with_errors(attribute, options = {})
      field = self.check_box(attribute, options)
      message = error_message_for(attribute)
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
