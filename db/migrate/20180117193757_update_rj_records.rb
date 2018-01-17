class UpdateRjRecords < ActiveRecord::Migration[5.1]
  def change
    rename_column :records_rj, :boy_beds, :man_lodging
    rename_column :records_rj, :girl_beds, :woman_lodging
  end
end
