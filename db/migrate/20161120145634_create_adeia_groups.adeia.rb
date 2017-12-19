# This migration comes from adeia (originally 20151003144650)
class CreateAdeiaGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :adeia_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
