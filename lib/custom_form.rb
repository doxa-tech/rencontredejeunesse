class CustomForm

  def initialize(form, url, view)
    @form = form
    @url = url
    @view = view
  end

  def render
    @view.form_tag @url do
      content = @form.fields.map do |f|
        Field.new(f).render
      end.join.html_safe
      content += @view.submit_tag "Envoyer"
    end
  end

  class Field
    include ActionView::Helpers::FormHelper

    def initialize(field = nil)
      @field = field
    end

    def render
      content = label_tag(@field.name)
      content += send(@field.field_type)
      return content.html_safe
    end

    private

    def text
      text_field_tag @field.name
    end

    def number
      number_field_tag @field.name
    end

    def email
      email_field_tag @field.name
    end

    def select_field
      select_tag @field.name, []
    end

  end

end