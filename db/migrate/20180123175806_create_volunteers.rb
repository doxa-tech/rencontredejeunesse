class CreateVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteers do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :sector
      t.text :comment
      t.integer :year
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end
