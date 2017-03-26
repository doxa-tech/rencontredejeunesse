class CreateTestimonies < ActiveRecord::Migration[5.0]
  def change
    create_table :testimonies do |t|
      t.text :message
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
