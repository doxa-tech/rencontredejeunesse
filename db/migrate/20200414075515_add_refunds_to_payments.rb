class AddRefundsToPayments < ActiveRecord::Migration[5.2]
  def change

    add_column :payments, :refund_amount, :integer
    add_column :payments, :refund_status, :integer

  end
end
