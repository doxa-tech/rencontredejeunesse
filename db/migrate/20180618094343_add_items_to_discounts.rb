class AddItemsToDiscounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :discounts, :product, :string
    
    create_table :discounts_items, id: false do |t|
      t.belongs_to :discount, index: true
      t.belongs_to :item, index: true
    end
  end
end
