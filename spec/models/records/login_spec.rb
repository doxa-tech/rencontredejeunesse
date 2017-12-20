require 'rails_helper'

module Records
  RSpec.describe "Login", :type => :model do

    it "calculates the right amount" do
      @product = create(:login)
      @product.participants = [
        Participants::Login.create(firstname: "Alfred", lastname: "Dupont", age: 84),
        Participants::Login.create(firstname: "John", lastname: "Smith", age: 26)
      ]
      @order = create(:order, product: @product)
      expect(@order.amount).to be (2 * Login::ENTRY_PRICE + Login::FEE) * 100
    end

  end
end
