class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :message
      t.belongs_to :user, foreign_key: true
      t.belongs_to :image, foreign_key: true

      t.timestamps
    end
  end
end
