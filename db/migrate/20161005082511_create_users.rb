class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :address
      t.integer :npa
      t.string :city
      t.string :country
      t.boolean :newsletter

      t.timestamps
    end
  end
end
