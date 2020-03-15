class CreateRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :refunds do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :order, foreign_key: true
      t.integer :refund_type
      t.string :comment

      t.timestamps
    end
  end
end
