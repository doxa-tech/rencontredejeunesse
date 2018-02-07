class Connect::VolunteersController < Connect::BaseController

  def index
    @volunteer = current_user.volunteer
  end

  def confirmation
    product = Records::Rj.new
    product.participants.build_from_user(current_user)
    @order = Order.create!(user: current_user, product: product,
      lump_sum: ((Records::Rj::VOLUNTEER_PRICE + Records::Rj::FEE) * 100)
    )
  end

end
