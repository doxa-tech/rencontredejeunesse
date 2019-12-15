class Form::Field < ApplicationRecord
  self.table_name = "fields"
  
  enum field_type: [:text, :number, :email, :select_field]

  validates :name, presence: true
  validates :field_type, presence: true
  validate :structure_of_options, if: :select_field?

  belongs_to :form
  has_many :completed_fields, class_name: "Form::CompletedField", dependent: :restrict_with_exception

  private

  # options = ["Autres", "Logisique" => ["Rangement", "Montage"]]
  def structure_of_options
    valid = options.is_a?(Array) && options.all? do |v| 
      v.is_a?(String) || v.is_a?(Hash) && v.values.all? do |s|
        s.is_a?(Array) && s.all? { |w| w.is_a?(String)}
      end
    end
    errors.add(:options, "n'est pas valide") unless valid
  end

end
