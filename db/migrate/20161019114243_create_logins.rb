class CreateLogins < ActiveRecord::Migration[5.0]
  def change
    create_table :records_login do |t|
      t.integer :entries
      t.string :group

      t.timestamps
    end
  end
end
