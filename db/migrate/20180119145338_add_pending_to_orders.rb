class AddPendingToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :pending, :boolean, default: false
  end
end
