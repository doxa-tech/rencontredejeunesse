class OrderTable < BaseTable

  def attributes
    [:id, :amount, :order_id, :human_id, :status, { user: :name }, :created_at]
  end

  def model
    Order
  end

  def belongs_to_associations
    [:user]
  end

  module Search

    def self.associations
      [:user]
    end

    def self.fields
      { users: [:firstname, :lastname, :email] }
    end

  end

end
