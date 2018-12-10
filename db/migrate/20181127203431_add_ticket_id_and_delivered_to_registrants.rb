class AddTicketIdAndDeliveredToRegistrants < ActiveRecord::Migration[5.1]
  def change
    add_column :registrants, :ticket_id, :bigint
    add_column :registrants, :delivered, :boolean, default: false
  end
end
