class DropTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :participants_rj
    drop_table :participants_login
    drop_table :records_rj
    drop_table :records_login
  end
end
