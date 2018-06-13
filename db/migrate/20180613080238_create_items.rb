class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :price
      t.integer :number
      t.boolean :active, default: true
      t.string :key

      t.timestamps
    end
  end
end
