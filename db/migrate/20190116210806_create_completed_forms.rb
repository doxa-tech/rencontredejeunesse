class CreateCompletedForms < ActiveRecord::Migration[5.1]
  def change
    create_table :completed_forms do |t|
      t.belongs_to :form, foreign_key: true

      t.timestamps
    end
  end
end
