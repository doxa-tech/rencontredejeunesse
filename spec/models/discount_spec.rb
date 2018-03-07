require 'rails_helper'

RSpec.describe "Discount", :type => :model do

  it "generates a code" do
    discount = create(:discount)
    expect(discount.code).to be_present
  end


  describe "#calculate_amount" do

    it "reduces an amount of money" do
      discount = create(:discount, category: :money, reduction: 2000)
      amount = discount.calculate_amount(6000)
      expect(amount).to eq 4000
    end

    it "reduces a percentage" do
      discount = create(:discount, category: :percent, reduction: 40)
      amount = discount.calculate_amount(10000)
      expect(amount).to eq 6000
    end

    it "offers free entries" do
      discount = create(:discount, category: :free, reduction: nil, number: 2)
      klass = discount.product_class
      amount = discount.calculate_amount (klass.ENTRY_PRICE * 3 + klass::FEE) * 100
      expect(amount).to eq (klass.ENTRY_PRICE + klass::FEE) * 100
    end

    it "reduces the amount to zero if there is only the fee" do
      discount = create(:discount, category: :free, reduction: nil, number: 1)
      klass = discount.product_class
      amount = discount.calculate_amount (klass.ENTRY_PRICE + klass::FEE) * 100
      expect(amount).to eq 0
    end

    it "doesn't return a negative amount" do
      discount = create(:discount, category: :money, reduction: 4000)
      amount = discount.calculate_amount(2000)
      expect(amount).to eq 0
    end

  end

end
