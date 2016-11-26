# This migration comes from adeia (originally 20151003144041)
class CreateAdeiaElements < ActiveRecord::Migration
  def change
    create_table :adeia_elements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
