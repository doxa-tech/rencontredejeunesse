class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name
      t.integer :field_type
      t.boolean :required
      t.belongs_to :form, foreign_key: true

      t.timestamps
    end
  end
end
