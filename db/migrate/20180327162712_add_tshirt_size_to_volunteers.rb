class AddTshirtSizeToVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :tshirt_size, :integer
  end
end
