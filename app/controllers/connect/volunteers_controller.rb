class Connect::VolunteersController < Connect::BaseController

  def index
    @volunteer = current_user.volunteer
  end

  def confirmation
    price = discount_for_volunteer? ? 0 : Records::Rj::VOLUNTEER_TOTAL
    price += 30 if has_lodging?
    product = Records::Rj.new
    product.participants.build_from_user(current_user, lodging: has_lodging?)
    @order = Order.create!(user: current_user, product: product, case: :volunteer,
      lump_sum: price * 100
    )
  end

  private

  def discount_for_volunteer?
    discount = Discount.find_by_code(params[:discount_code])
    discount && discount.free? && discount.number == 1 && discount.product == "Records::Rj" && !discount.used
  end

  def has_lodging?
    params[:lodging].present?
  end

end
