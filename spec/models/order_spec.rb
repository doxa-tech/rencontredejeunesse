require 'rails_helper'

RSpec.describe "Order", :type => :model do

  it "generates the IDs" do
    @order = create(:order)
    expect(@order.human_id).to be_present
    expect(@order.order_id).to be_present
  end

  it "assigns invoice as payment method when the amount is above the limit" do
    @participants = build_list(:rj_participant, 15, lodging: true)
    @product = create(:rj, participants: @participants)
    @order = create(:order, product: @product)
    expect(@order.payment_method).to eq "invoice"
  end

  it "assigns postfinance as payment method when the amount is under the limit" do
    @order = create(:order)
    expect(@order.payment_method).to eq "postfinance"
  end

  it "doesn't calculate amount if a lump sum is used" do
    @order = build(:order)
    @order.lump_sum = 1000
    @order.save
    expect(@order.amount).to eq 1000
  end

  it "assigns the right amount on create" do
    @order = create(:order)
    expect(@order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
  end

  it "assigns the right amount on update" do
    @order = create(:order)
    @order.product.participants.first.lodging = true
    @order.save
    expect(@order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE) * 100
  end

  it "assigns the right number of entries when deleting a participant" do
    participants = build_list(:rj_participant, 2)
    product = create(:rj, participants: participants)
    @order = create(:order, product: product)
    @order.product.participants.first.mark_for_destruction
    @order.save
    expect(@order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
  end

end
