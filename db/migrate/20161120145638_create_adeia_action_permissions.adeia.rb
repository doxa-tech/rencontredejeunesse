# This migration comes from adeia (originally 20151003150806)
class CreateAdeiaActionPermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :adeia_action_permissions do |t|
      t.references :adeia_action, index: true, foreign_key: true
      t.references :adeia_permission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
