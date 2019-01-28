class RegistrantTable < BaseTable

  def attributes
    [:id, :ticket_id, :firstname, :lastname, :delivered, :created_at, :updated_at]
  end

  def model
    Registrant
  end

  def belongs_to_associations
    [:order, :item]
  end

  module Search

    def self.associations
      [:order, :item ]
    end

    def self.fields
      { registrants: [:firstname, :lastname]}
    end

  end

end
