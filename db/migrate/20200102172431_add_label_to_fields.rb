class AddLabelToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :label, :string
  end
end
