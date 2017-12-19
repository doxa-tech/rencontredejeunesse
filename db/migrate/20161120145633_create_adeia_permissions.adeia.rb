# This migration comes from adeia (originally 20151003144208)
class CreateAdeiaPermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :adeia_permissions do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :adeia_element, index: true, foreign_key: true
      t.integer :permission_type
      t.boolean :read_right, default: false
      t.boolean :create_right, default: false
      t.boolean :update_right, default: false
      t.boolean :destroy_right, default: false
      t.integer :resource_id

      t.timestamps null: false
    end
  end
end
