require 'rails_helper'

module Records
  RSpec.describe "Login", :type => :model do

    it "calculates the right amount" do
      participants = [
        Participants::Login.new(gender: "male", firstname: "Alfred", lastname: "Dupont", email: "alfred@dupont.com", age: 84),
        Participants::Login.new(gender: "male", firstname: "John", lastname: "Smith", email: "john@smith.com", age: 26)
      ]
      @product = create(:login, participants: participants)
      @order = create(:order, product: @product)
      expect(@order.amount).to be (2 * Login::ENTRY_PRICE + Login::FEE) * 100
    end

  end
end
