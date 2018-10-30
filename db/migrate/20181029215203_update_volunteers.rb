class UpdateVolunteers < ActiveRecord::Migration[5.1]
  def change

    add_reference :volunteers, :order, foreign_key: true
    add_reference :volunteers, :volunteering, foreign_key: true

    remove_column :volunteers, :tshirt_size, :integer
    remove_column :volunteers, :confirmed, :boolean
    remove_column :volunteers, :year, :integer

  end
end
