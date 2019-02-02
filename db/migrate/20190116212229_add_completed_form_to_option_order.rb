class AddCompletedFormToOptionOrder < ActiveRecord::Migration[5.1]

  def change
    add_reference :option_orders, :completed_form, foreign_key: true
  end
  
end
