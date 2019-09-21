class AddKeyAndDescriptionToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :key, :string
    add_column :forms, :description, :string
  end
end
