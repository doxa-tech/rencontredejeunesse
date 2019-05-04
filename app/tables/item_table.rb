class ItemTable < BaseTable

  def attributes
    [:id, :name, :description, :number, :price, :active, :valid_from, :valid_until, { order_bundle: :name }, :created_at, :updated_at]
  end

  def model
    Item
  end

  def belongs_to_associations
    [:order_bundle]
  end

  module Search

    def self.associations
      [:order_bundle]
    end

    def self.fields
      { order_bundles: [:name] }
    end

  end

end
