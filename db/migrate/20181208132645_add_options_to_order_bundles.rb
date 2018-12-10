class AddOptionsToOrderBundles < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    add_column :order_bundles, :options, :hstore
  end
end
