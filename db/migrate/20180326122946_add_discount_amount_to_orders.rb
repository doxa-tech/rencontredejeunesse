class AddDiscountAmountToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :discount_amount, :integer, default: 0
  end
end
