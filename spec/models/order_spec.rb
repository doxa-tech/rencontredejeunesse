require 'rails_helper'
require 'interfaces/pdf_invoice'

RSpec.describe "Order", :type => :model do

  # TODO: test invoice deadline

  it_should_behave_like "an invoice PDF responder" do
    let(:responder) do
      order = create(:order_with_items)
      order.invoice_pdf_adapter
    end
  end

  it "generates the IDs" do
    order = create(:order)
    expect(order.order_id).to be_present
  end

  describe "#assign_amount" do

    it "saves the amount" do
      order = create(:order_with_items)
      expect(order.amount).not_to eq 0
    end

    it "sets the amount to zero if there is only the fee" do
      order = create(:order_with_items)
      discount = create(:discount, category: :free, number: 1, items: order.items)
      order.discount_code = discount.code
      order.save
      expect(order.amount).to eq 0
    end

    it "sets the amount to zero if it is negative" do
      order = create(:order_with_items)
      discount = create(:discount, category: :money, reduction: order.amount + 1000)
      order.discount_code = discount.code
      order.save
      expect(order.amount).to eq 0
    end

    it "saves the amount of the discount" do
      order = create(:order_with_items)
      discount = create(:discount, category: :money, reduction: 2000)
      order.discount_code = discount.code
      order.save
      expect(order.discount_amount).to eq 2000
    end

  end

  describe "#assign_payment" do

    it "creates a main payment" do
      order = create(:order_with_items)
      expect(order.main_payment.amount).to eq order.amount
      expect(order.main_payment.payment_type).to eq "main"
    end

    it "updates the main payment when there is no status" do
      order = create(:order_with_items)
      order.order_items << create(:order_item, order: order)
      order.save!
      expect(order.main_payment.amount).to eq order.amount
    end

    it "doesn't update the main when there is a status" do
      order = create(:order_with_items)
      paid_amount = order.amount
      order.main_payment.update_attributes!(status: 9)
      order.order_items << create(:order_item, order: order)
      order.save!
      expect(order.main_payment.amount).to eq paid_amount
    end

    it "updates order status" do
      order = create(:order_with_items)
      order.main_payment.update_attributes!(status: 9)
      order.order_items << create(:order_item, order: order)
      order.save!
      expect(order.status).to eq "unpaid"
    end

  end
  
  context "discounts" do

    it "apply a valid discount" do
      order = create(:order_with_items)
      discount = create(:discount)
      order.discount_code = discount.code
      expect(order.discount).to eq discount
    end

    it "doesn't apply an non valid code" do
      order = create(:order_with_items)
      order.discount_code = "FALS"
      order.valid?
      expect(order.errors[:discount_code]).not_to be_empty
    end

    it "doesn't apply an already used discount" do
      order = create(:order_with_items)
      discount = create(:discount, used: true)
      order.discount_code = discount.code
      expect { order.save! }.to raise_error ActiveRecord::RecordInvalid
    end

  end

end
