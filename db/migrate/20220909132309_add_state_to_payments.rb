class AddStateToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :state, :integer, default: :pending
  end
end
