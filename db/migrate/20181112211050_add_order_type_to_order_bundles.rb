class AddOrderTypeToOrderBundles < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_bundles, :order_type, foreign_key: true
  end
end
