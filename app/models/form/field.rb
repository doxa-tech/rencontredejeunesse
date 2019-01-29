class Form::Field < ApplicationRecord
  self.table_name = "fields"
  
  enum field_type: [:text, :number, :email, :select_field]

  belongs_to :form
  has_many :completed_fields, class_name: "Form::CompletedField"

end
