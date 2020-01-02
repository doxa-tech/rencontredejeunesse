class RemoveOrderType < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_bundles, :order_type_id
    drop_table :order_types
  end
end
