class Form < ApplicationRecord

  has_many :fields, class_name: "Form::Field"

end
