class UpdateOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :payid, :bigint
    remove_column :orders, :product_type, :string
    remove_column :orders, :product_id, :integer
    remove_column :orders, :human_id, :string
    remove_column :orders, :payment_method, :integer
    remove_column :orders, :delivered, :boolean
    rename_column :orders, :case, :order_type

    reversible do |dir|
      dir.up do
        change_column :orders, :order_id, 'bigint USING order_id::bigint'
        change_column :orders, :amount, :integer, default: 0
      end
      dir.down do
        change_column :orders, :order_id, :string
        change_column :orders, :amount, :integer, default: nil
      end
    end
  end
end
