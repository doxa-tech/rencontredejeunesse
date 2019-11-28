class AddFormToOrderBundles < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_bundles, :form, foreign_key: true
    add_column :order_bundles, :bundle_type, :integer
    # remove_column :order_bundles, :order_type_id, :integer
    add_column :order_bundles, :order_type, :integer
  end
end
