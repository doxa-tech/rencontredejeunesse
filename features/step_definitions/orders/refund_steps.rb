Given("I made an order") do
  @order = create(:event_order, user: @user)
  @order.main_payment.update(status: 9)
end

When("I fill in the refund form") do
  select OrdersHelper.summary(@order), from: "Commande"
  choose("Je fais don de mon inscription")
  fill_in("Commentaire", with: "Merci !")
  click_button "Envoyer ma demande"
end