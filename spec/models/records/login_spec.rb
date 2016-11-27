require 'rails_helper'

module Records
  RSpec.describe "Login", :type => :model do

    it "calculates the right amount" do
      @product = create(:login, entries: 3)
      @order = create(:order, product: @product)
      expect(@order.amount).to be (3 * Login::ENTRY_PRICE + Login::FEE) * 100
    end

  end
end
