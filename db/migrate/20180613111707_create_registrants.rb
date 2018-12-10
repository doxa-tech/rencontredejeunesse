class CreateRegistrants < ActiveRecord::Migration[5.1]
  def change
    create_table :registrants do |t|
      t.integer :gender
      t.string :firstname
      t.string :lastname
      t.date :birthday
      t.belongs_to :item, foreign_key: true
      t.belongs_to :order, foreign_key: true

      t.timestamps
    end
  end
end
