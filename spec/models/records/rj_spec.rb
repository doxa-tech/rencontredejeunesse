require 'rails_helper'

module Records
  RSpec.describe "Rj", :type => :model do

    it "calculates the right amount" do
      participants = [
        Participants::Rj.new(lodging: true, gender: "male", firstname: "Alfred", lastname: "Dupont", birthday: Date.new(2001, 01, 13)),
        Participants::Rj.new(lodging: false, gender: "male", firstname: "John", lastname: "Smith", birthday: Date.new(1999, 06, 23))
      ]
      @product = create(:rj, participants: participants)
      @order = create(:order, product: @product)
      expect(@order.amount).to be(((2 * Rj.ENTRY_PRICE) + 1 * Rj::LODGING_PRICE + Rj::FEE) * 100)
    end

    it "calculates the right lodging" do
      participants = [
        Participants::Rj.create(lodging: true, gender: "male", firstname: "Alfred", lastname: "Dupont", birthday: Date.new(2001, 01, 13)),
        Participants::Rj.create(lodging: true, gender: "female", firstname: "Angel", lastname: "Smith", birthday: Date.new(1999, 06, 23))
      ]
      @product = create(:rj, participants: participants)
      @order = create(:order, product: @product)
      expect(@order.product.man_lodging).to be(1)
      expect(@order.product.woman_lodging).to be(1)
    end

  end
end
