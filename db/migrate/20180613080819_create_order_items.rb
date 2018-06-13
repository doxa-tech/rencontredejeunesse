class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, foreign_key: true, index: true
      t.belongs_to :item, foreign_key: true, index: true

      t.timestamps
    end
  end
end
