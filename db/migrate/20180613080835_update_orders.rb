class UpdateOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :payid
    remove_column :orders, :product_type
    remove_column :orders, :product_id
    remove_column :orders, :human_id
    remove_column :orders, :payment_method
    remove_column :orders, :delivered
    remove_column :orders, :case
  end
end
