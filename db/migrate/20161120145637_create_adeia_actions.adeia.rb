# This migration comes from adeia (originally 20151003150747)
class CreateAdeiaActions < ActiveRecord::Migration
  def change
    create_table :adeia_actions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
