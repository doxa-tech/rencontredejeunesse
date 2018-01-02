class StandardFormBuilder < ActionView::Helpers::FormBuilder

    def field_with_errors(type, attribute, options = {})
      tag = self.send("#{type}_field", attribute, options)
      message = error_message_for(attribute)
      %(<div class="field">#{tag}</div><div class="error-message">#{message}</div>).html_safe
    end

    private

    def error_message_for(attribute)
      @object.errors.full_messages_for(attribute).join(" / ")
    end

end
