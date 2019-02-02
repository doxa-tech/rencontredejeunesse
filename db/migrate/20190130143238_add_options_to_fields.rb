class AddOptionsToFields < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :options, :jsonb
  end
end
