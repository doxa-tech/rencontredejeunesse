class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :amount
      t.integer :order_id
      t.integer :status

      t.belongs_to :user, index: true
      t.references :product, polymorphic: true, index: true

      t.timestamps
    end
  end
end
