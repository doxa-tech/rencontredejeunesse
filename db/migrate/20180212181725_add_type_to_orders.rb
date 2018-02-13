class AddTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :case, :integer, default: 0
  end
end
