class AddFormToOrderType < ActiveRecord::Migration[5.1]
  
  def change
    add_reference :order_types, :form, foreign_key: true
  end

end
