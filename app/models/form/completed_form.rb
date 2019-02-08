class Form::CompletedForm < ApplicationRecord
  self.table_name = "completed_forms"
  
  belongs_to :form
  has_many :completed_fields, class_name: "Form::CompletedField", dependent: :destroy

  # display the completed field in a string
  def to_s
    completed_fields.includes(:field).map do |f|
      label, value = CustomForm::Field.display(f)
      "#{label}: #{value}"
    end.join(", ")
  end


end
