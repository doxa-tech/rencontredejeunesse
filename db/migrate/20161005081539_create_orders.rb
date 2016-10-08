class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :amount
      t.string :order_id
      t.integer :status
      t.integer :payid

      t.belongs_to :user, index: true, foreign_key: true
      t.references :product, polymorphic: true, index: true

      t.timestamps
    end
  end
end
