# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Fake item to order
# item = Item.create({
#   name: "Billet RJ test",
#   description: "Evénement fictif pour l'environement de dev.",
#   price: 5550,
#   key: "RJ-test",
#   number: 20189424,
#   active: true
# })
# Set order status to paid
# User.last.orders.last.update_attribute(:status, :delivered)
# Set payement to status 9
# Payment.last.update_attribute(:status, 9)
# Set time of payment
# Payment.last.update_attribute(.:time, Time.current)
# Assign item to order
# OrderItem.create(order_id: 1,item_id: 1, quantity: 1)