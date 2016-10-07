class CreateVolunteers < ActiveRecord::Migration[5.0]
  def change
    create_table :volunteers do |t|
      t.integer :sector
      t.belongs_to :user, index: true, foreign_key: true
      t.string :comment
      t.string :other

      t.timestamps
    end
  end
end
