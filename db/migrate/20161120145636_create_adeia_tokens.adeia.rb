# This migration comes from adeia (originally 20151003150524)
class CreateAdeiaTokens < ActiveRecord::Migration[4.2]
  def change
    create_table :adeia_tokens do |t|
      t.string :token
      t.boolean :is_valid
      t.references :adeia_permission, index: true, foreign_key: true
      t.date :exp_at

      t.timestamps null: false
    end
  end
end
