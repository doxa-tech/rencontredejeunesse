class AddActiveToOrderBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :order_bundles, :active, :boolean, default: true
  end
end
