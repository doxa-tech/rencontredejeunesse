class AddOpenToOrderBundles < ActiveRecord::Migration[5.1]
  def change
    add_column :order_bundles, :open, :boolean, default: true
  end
end
