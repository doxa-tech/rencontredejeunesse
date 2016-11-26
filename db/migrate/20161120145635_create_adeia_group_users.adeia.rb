# This migration comes from adeia (originally 20151003144706)
class CreateAdeiaGroupUsers < ActiveRecord::Migration
  def change
    create_table :adeia_group_users do |t|
      t.references :adeia_group, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
