require 'rails_helper'

RSpec.describe Connect::VolunteersController, :type => :controller do

  it "saves the amount of the discount" do
    user = create(:user)
    discount = create(:discount, category: :free, number: 1)
    cookies[:remember_token] = { value: user.remember_token }
    post :confirmation, params: { discount_code: discount.code }
    expect(assigns(:order).discount_amount).to eq 53
  end

end
