class AddExpirationToForms < ActiveRecord::Migration[5.2]
  def change
    add_column :forms, :active, :boolean, default: true
    add_column :forms, :valid_from, :date
    add_column :forms, :valid_until, :date
  end
end
