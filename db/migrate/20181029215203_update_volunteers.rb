class UpdateVolunteers < ActiveRecord::Migration[5.1]
  def change

    add_reference :volunteers, :order, foreign_key: true
    add_reference :volunteers, :order_bundle, foreign_key: true

    remove_column :volunteers, :tshirt_size, :integer
    remove_column :volunteers, :confirmed, :boolean
    remove_column :volunteers, :year, :integer

    rename_table :volunteers, :option_orders

  end
end
