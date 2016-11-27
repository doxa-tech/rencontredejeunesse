require 'rails_helper'

RSpec.describe "Order", :type => :model do

  it "generates the IDs" do
    @order = create(:order)
    expect(@order.human_id).to be_present
    expect(@order.order_id).to be_present
  end

end
