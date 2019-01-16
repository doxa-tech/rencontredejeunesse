class Form::CompletedForm < ApplicationRecord
  self.table_name = "completed_forms"
  
  belongs_to :form
  has_many :completed_fields, class_name: "Form::CompletedField"

end
