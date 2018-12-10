class AddStiTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :order_type
    add_column :orders, :type, :string
  end
end
