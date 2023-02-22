class AddRefundStateToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :refund_state, :integer
  end
end
