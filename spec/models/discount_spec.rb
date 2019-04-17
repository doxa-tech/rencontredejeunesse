require 'rails_helper'

RSpec.describe "Discount", :type => :model do

  it "generates a code" do
    discount = create(:discount)
    expect(discount.code).to be_present
  end

  describe "#calculate_discount" do

    it "reduces an amount of money" do
      order = create(:order)
      discount = create(:discount, category: :money, reduction: 2000)
      amount = discount.calculate_discount(order)
      expect(amount).to eq 2000
    end

    it "reduces a percentage on the order" do
      order = create(:order_with_items)
      discount = create(:discount, category: :percent, reduction: 40)
      amount = discount.calculate_discount(order)
      expect(amount).to eq (order.amount * 0.4)
    end

    it "reduces a percentage on multiple items" do
      items = create_list(:item, 2)
      order = create(:order)
      order.order_items.create([{ quantity: 1, item: items[0] }, { quantity: 2, item: items[1] }])
      discount = create(:discount, category: :percent, reduction: 40, items: items)
      amount = discount.calculate_discount(order)
      expect(amount).to eq items[0].price * 3 * 0.4
    end

    it "does not reduce a percentage" do
      order = create(:order_with_items)
      discount = create(:discount, category: :percent, reduction: 40, items: create_list(:item, 2))
      amount = discount.calculate_discount(order)
      expect(amount).to eq 0
    end

    it "offers an item multiple times limited by number" do
      order = create(:order_with_items, number: 1, quantity: 3)
      discount = create(:discount, category: :free, reduction: nil, number: 2, items: order.items)
      amount = discount.calculate_discount(order)
      expect(amount).to eq (order.items[0].price * 2)
    end

    it "offers multiple items limited by number" do
      order = create(:order_with_items, number: 3)
      discount = create(:discount, category: :free, reduction: nil, number: 2, items: order.items)
      amount = discount.calculate_discount(order)
      expect(amount).to eq (order.items[0].price * 2)
    end

    it "does not offer a free item" do
      order = create(:order_with_items)
      discount = create(:discount, category: :free, reduction: nil, number: 1, items: [create(:item)])
      amount = discount.calculate_discount(order)
      expect(amount).to eq 0
    end

  end

end
