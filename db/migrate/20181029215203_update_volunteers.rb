class UpdateVolunteers < ActiveRecord::Migration[5.1]
  def change

    add_reference :volunteers, :order, foreign_key: true
    add_reference :volunteers, :volunteering, foreign_key: true

    rename_column :volunteers, :sector, :options

    remove_column :volunteers, :tshirt_size
    remove_column :volunteers, :confirmed
    remove_column :volunteers, :year

  end
end
