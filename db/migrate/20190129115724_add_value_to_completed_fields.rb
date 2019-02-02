class AddValueToCompletedFields < ActiveRecord::Migration[5.1]
  def change
    add_column :completed_fields, :value, :string
  end
end
