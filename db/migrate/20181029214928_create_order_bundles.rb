class CreateOrderBundles < ActiveRecord::Migration[5.1]
  def change
    create_table :order_bundles do |t|
      t.string :name
      t.text :description
      t.string :key

      t.timestamps
    end
  end
end
