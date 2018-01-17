class RemoveBedsFromRjRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :records_rj, :girl_beds
    remove_column :records_rj, :boy_beds
  end
end
