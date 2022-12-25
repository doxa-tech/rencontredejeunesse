require 'rails_helper'

RSpec.describe OrderCompletion do

  it "rejects an order with the payment method postfinance" do
    order = create(:event_order)
    create(:payment, order: order, amount: order.amount)
    completion = OrderCompletion.new(order)
    expect { completion.complete }.to raise_error ArgumentError
  end

  describe "#common_steps" do
  
    it "sets a discount as used" do
      order = create(:event_order, discount: create(:discount))
      create(:payment, order: order, amount: order.amount)
      OrderCompletion.new(order).complete(:postfinance)
      expect(order.discount.used).to eq true
    end

    it "sends a confirmation email" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      OrderCompletion.new(order).complete(:postfinance)
      expect(ActionMailer::Base.deliveries.any? { |mail| mail.subject == "Confirmation de commande" }).to be true
    end

  end

  describe "#invoice" do

    it "creates a payment with the state processing" do
      order = create(:event_order)
      item = create(:item_with_bundle, price: 10000)
      order.registrants = create_list(:registrant, 10, order: order, item: item)
      order.save!
      OrderCompletion.new(order).complete
      expect(order.main_payment.state).to eq "processing"
    end

  end

  describe "#postfinance" do

    it "sends an email with the pass" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      OrderCompletion.new(order).complete(:postfinance)
      expect(ActionMailer::Base.deliveries.any? { |mail| mail.subject == "Pass pour ta commande" }).to be true
    end

  end

  describe "#free" do

    it "sends an email with the pass" do
      order = create(:event_order)
      discount = create(:discount, category: :free, number: 1, items: order.items)
      order.discount = discount
      order.save!
      OrderCompletion.new(order).complete
      expect(ActionMailer::Base.deliveries.any? { |mail| mail.subject == "Pass pour ta commande" }).to be true
    end

    it "creates no payment" do
      order = create(:event_order)
      discount = create(:discount, category: :free, number: 1, items: order.items)
      order.discount = discount
      order.save!
      OrderCompletion.new(order).complete
      expect(order.main_payment).to be_nil
    end

    it "sets the order status to paid" do
      order = create(:event_order)
      discount = create(:discount, category: :free, number: 1, items: order.items)
      order.discount = discount
      order.save!
      OrderCompletion.new(order).complete
      expect(order.status).to eq "paid"
    end

  end
end