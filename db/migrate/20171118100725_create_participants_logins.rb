class CreateParticipantsLogins < ActiveRecord::Migration[5.1]

  def change
    create_table :participants_login do |t|
      t.integer :gender
      t.string :firstname
      t.string :lastname
      t.integer :age
      t.belongs_to :records_login, index: true, foreign_key: { to_table: :records_login }

      t.timestamps
    end
  end
end
