class AddCommentsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :note, :text
  end
end
