class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants_rj do |t|
      t.string :firstname
      t.string :lastname
      t.integer :age
      t.belongs_to :records_rj, index: true, foreign_key: true

      t.timestamps
    end
  end
end
