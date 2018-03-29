require 'rails_helper'
require 'interfaces/pdf_invoice'

RSpec.describe "Order", :type => :model do

  it_should_behave_like "a PDF invoice responder" do
    let(:responder)  {Adapters::OrderPassRjPDFAdapter.new(create(:order))}
  end

  it "generates the IDs" do
    order = create(:order)
    expect(order.human_id).to be_present
    expect(order.order_id).to be_present
  end

  describe "payment method" do

    it "assigns invoice as payment method when the amount is above the limit" do
      participants = build_list(:rj_participant, 15, lodging: true)
      product = create(:rj, participants: participants)
      order = create(:order, product: product)
      expect(order.payment_method).to eq "invoice"
    end

    it "assigns postfinance as payment method when the amount is under the limit" do
      order = create(:order)
      expect(order.payment_method).to eq "postfinance"
    end

  end

  describe "amount" do

    it "doesn't calculate amount if a lump sum is used" do
      order = build(:order)
      order.lump_sum = 1000
      order.save
      expect(order.amount).to eq 1000
    end

    it "assigns the right amount on create" do
      order = create(:order)
      expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
    end

    it "assigns the right amount on update" do
      order = create(:order)
      order.product.participants.first.lodging = true
      order.save
      expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE) * 100
    end

    it "assigns the right number of entries when deleting a participant" do
      participants = build_list(:rj_participant, 2)
      product = create(:rj, participants: participants)
      order = create(:order, product: product)
      order.product.participants.first.mark_for_destruction
      order.save
      expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
    end

  end

  describe "discount" do

    it "omits the fee if the amount is zero" do
      order = build(:order)
      discount = create(:discount, category: :free, number: 1, product: "Records::Rj")
      order.discount_code = discount.code
      order.save
      expect(order.amount).to eq 0
    end

    it "doesn't apply an already used discount" do
      order = build(:order)
      discount = create(:discount, used: true)
      order.discount_code = discount.code
      expect { order.save! }.to raise_error ActiveRecord::RecordInvalid
    end

    it "doesn't apply a discount with the wrong product" do
      order = build(:order)
      discount = create(:discount, product: "Records::Login")
      order.discount_code = discount.code
      expect { order.save! }.to raise_error ActiveRecord::RecordInvalid
    end

    it "saves the amount of the discount" do
      order = build(:order)
      discount = create(:discount, category: :free, number: 1, product: "Records::Rj")
      order.discount_code = discount.code
      order.save
      expect(order.discount_amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
    end

  end

end
