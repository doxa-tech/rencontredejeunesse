require 'rails_helper'

RSpec.describe Orders::RjController, :type => :controller do
  before(:each) do
    @order = create(:order)
  end

  it "saves the volunteer options on create" do
    volunteer_params = { "door"=>"1", "install"=>"0", "other"=>"Available", "comment"=>"Thank you" }
    post :create, params: {
      volunteer_form: volunteer_params,
      order: { conditions: "1", user_attributes: build(:user).attributes.symbolize_keys }
    }
    volunteers = assigns(:order).user.volunteers
    expect(volunteers.size).to eq(2)
    expect(volunteers.second.other).to eq("Available")
    expect(volunteers.first.comment).to eq("Thank you")
    expect(volunteers.first.sector).to eq("door")
  end

  it "saves the volunteer options on update" do
    order = create(:order)
    volunteer = create(:volunteer, sector: "door", comment: "Thank you")
    volunteer_params = { "install"=>"1" }
    post :update, params: {
      id: order.order_id,
      volunteer_form: volunteer_params,
      order: { conditions: "1", user_attributes: order.user.attributes.symbolize_keys }
    }
    volunteers = assigns(:order).user.volunteers
    expect(volunteers.size).to eq(1)
    expect(volunteers.first.sector).to eq("install")
  end

end
