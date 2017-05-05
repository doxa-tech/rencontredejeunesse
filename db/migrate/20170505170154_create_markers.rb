class CreateMarkers < ActiveRecord::Migration[5.0]
  def change
    create_table :markers do |t|
      t.decimal :lat
      t.decimal :lng
      t.string :title
      t.string :content
    end
  end
end
