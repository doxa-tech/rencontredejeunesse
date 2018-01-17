class UpdateRjParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants_rj, :gender, :integer
    add_column :participants_rj, :birthday, :datetime
    add_column :participants_rj, :accommodation, :boolean
    remove_column :participants_rj, :age
  end
end
