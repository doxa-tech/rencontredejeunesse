class AddLimitToOrderBundles < ActiveRecord::Migration[5.1]
  def change
    add_column :order_bundles, :limit, :integer
  end
end
