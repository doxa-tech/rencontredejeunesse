class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :method
      t.datetime :time
      t.integer :status
      t.bigint :payid
      t.belongs_to :order, foreign_key: true

      t.timestamps
    end
  end
end
