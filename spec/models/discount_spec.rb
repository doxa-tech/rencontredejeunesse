require 'rails_helper'

RSpec.describe "Discount", :type => :model do

  it "generates a code" do
    discount = create(:discount)
    expect(discount.code).to be_present
  end


  describe "#calculate_discount" do

    it "reduces an amount of money" do
      discount = create(:discount, category: :money, reduction: 20)
      amount = discount.calculate_discount(60)
      expect(amount).to eq 40
    end

    it "reduces a percentage" do
      discount = create(:discount, category: :percent, reduction: 40)
      amount = discount.calculate_discount(100)
      expect(amount).to eq 60
    end

    it "offers free entries" do
      discount = create(:discount, category: :free, reduction: nil, number: 2)
      amount = discount.calculate_discount(185)
      expect(amount).to eq 65
    end

  end

end
