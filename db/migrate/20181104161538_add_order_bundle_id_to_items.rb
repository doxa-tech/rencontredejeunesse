class AddOrderBundleIdToItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :order_bundle, foreign_key: true
  end
end
