class CreateOrderTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :order_types do |t|
      t.string :name
      t.belongs_to :supertype, index: true

      t.timestamps
    end
  end
end
