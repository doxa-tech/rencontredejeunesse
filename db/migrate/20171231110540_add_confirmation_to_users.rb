class AddConfirmationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :confirmed, :boolean, default: false
    add_column :users, :verify_token, :string
  end
end
