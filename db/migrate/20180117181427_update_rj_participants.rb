class UpdateRjParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants_rj, :gender, :integer
    add_column :participants_rj, :birthday, :date
    add_column :participants_rj, :lodging, :boolean, default: false
    remove_column :participants_rj, :age, :integer
  end
end
