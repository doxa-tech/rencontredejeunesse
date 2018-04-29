class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :token
      t.integer :platform

      t.timestamps
    end
  end
end
