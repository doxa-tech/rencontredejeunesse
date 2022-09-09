class AddDefaultStatusToOrders < ActiveRecord::Migration[5.2]
  def change
    change_column_default :orders, :status, from: nil, to: :progress
  end
end
