class CreateCompletedFields < ActiveRecord::Migration[5.1]
  def change
    create_table :completed_fields do |t|
      t.belongs_to :completed_form, foreign_key: true
      t.belongs_to :field, foreign_key: true

      t.timestamps
    end
  end
end
