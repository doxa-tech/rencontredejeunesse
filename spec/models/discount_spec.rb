require 'rails_helper'

RSpec.describe "Discount", :type => :model do

  it "generates a code" do
    discount = create(:discount)
    expect(discount.code).to be_present
  end


  describe "#calculate_discount" do

    it "reduces an amount of money" do
      discount = create(:discount, category: :money, reduction: 2000)
      amount = discount.calculate_discount(6000)
      expect(amount).to eq 4000
    end

    it "reduces a percentage" do
      discount = create(:discount, category: :percent, reduction: 40)
      amount = discount.calculate_discount(10000)
      expect(amount).to eq 6000
    end

    it "offers free entries" do
      discount = create(:discount, category: :free, reduction: nil, number: 2)
      amount = discount.calculate_discount(18500)
      expect(amount).to eq 6500
    end

  end

end
