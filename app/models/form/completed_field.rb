class Form::CompletedField < ApplicationRecord
  self.table_name = "completed_fields"

  belongs_to :completed_form, class_name: "Form::CompletedForm"
  belongs_to :field, class_name: "Form::Field"

end
