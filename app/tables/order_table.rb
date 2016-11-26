class OrderTable < BaseTable

  def attributes
    [:id, :print_amount, :order_id, :status, { user: :name }, :created_at]
  end

  def model
    Order
  end

end
