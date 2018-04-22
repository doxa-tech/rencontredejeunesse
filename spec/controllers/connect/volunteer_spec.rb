require 'rails_helper'

RSpec.describe Connect::VolunteersController, :type => :controller do
  before(:each) do
    @user = create(:user)
    cookies[:remember_token] = { value: @user.remember_token }
  end

  it "saves the right amount without lodging" do
    post :confirmation
    expect(assigns(:order).amount).to eq 5300
  end

  it "saves the right amount with lodging" do
    post :confirmation, params: { lodging: "1" }
    expect(assigns(:order).amount).to eq 8300
  end

  it "applies a discount" do
    discount = create(:discount, category: :free, number: 1)
    post :confirmation, params: { discount_code: discount.code }
    expect(assigns(:order).amount).to eq 0
  end

  it "saves the amount of the discount" do
    discount = create(:discount, category: :free, number: 1)
    post :confirmation, params: { discount_code: discount.code }
    expect(assigns(:order).discount_amount).to eq 5300
  end

end
