class AddNoteToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :note, :string
  end
end
