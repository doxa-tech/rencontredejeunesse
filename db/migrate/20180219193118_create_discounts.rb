class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :code
      t.integer :reduction
      t.integer :category
      t.string :product
      t.integer :number
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
