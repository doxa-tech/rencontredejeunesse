require 'rails_helper'

module Records
  RSpec.describe "Rj", :type => :model do

    it "calculates the right amount" do
      @product = create(:rj, entries: 1, boy_beds: 1, girl_beds: 2)
      puts @product.to_yaml
      @order = create(:order, product: @product)
      expect(@order.amount).to be(((1 * Rj.ENTRY_PRICE) + (1 + 2) * Rj::BED_PRICE + Rj::FEE) * 100)
    end

  end
end
