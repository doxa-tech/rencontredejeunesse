class AddHumanIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :human_id, :string, index: true
  end
end
