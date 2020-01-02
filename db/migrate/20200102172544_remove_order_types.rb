class RemoveOrderTypes < ActiveRecord::Migration[5.2]
  def change
    drop_table :order_types
    remove_column :order_bundles, :order_type_id
  end
end
