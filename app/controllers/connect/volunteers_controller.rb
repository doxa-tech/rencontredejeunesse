class Connect::VolunteersController < Connect::BaseController

  def index
    @volunteer = current_user.volunteer
  end

  def confirmation
    product = Records::Rj.new
    product.participants.build_from_user(current_user)
    @order = Order.create!(user: current_user, product: product, type: :volunteer
      lump_sum: ((Records::Rj::VOLUNTEER_TOTAL) * 100)
    )
  end

end
