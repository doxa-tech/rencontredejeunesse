class AddDiscountToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :discount, foreign_key: true
  end
end
