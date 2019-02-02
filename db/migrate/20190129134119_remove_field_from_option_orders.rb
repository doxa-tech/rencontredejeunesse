class RemoveFieldFromOptionOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :option_orders, :comment
    remove_column :option_orders, :sector
  end
end
