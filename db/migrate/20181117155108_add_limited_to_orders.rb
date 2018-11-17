class AddLimitedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :limited, :boolean, default: false
  end
end
