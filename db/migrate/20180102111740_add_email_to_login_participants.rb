class AddEmailToLoginParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants_login, :email, :string
  end
end
