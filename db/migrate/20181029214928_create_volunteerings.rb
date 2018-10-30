class CreateVolunteerings < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteerings do |t|
      t.string :name
      t.text :description
      t.belongs_to :item, foreign_key: true

      t.timestamps
    end
  end
end
