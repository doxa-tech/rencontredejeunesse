namespace :order do

  desc "Setup the superuser"
  task generate_order_id: :environment do
    Order.all.each do |order|
      order_id = (Time.now.year%100)*(10**12) + SecureRandom.random_number(10**10)*(10**2) + 01
      order.update_attribute(:order_id, order_id)
    end
    puts "Orders updated with a new order id !"
  end

end
