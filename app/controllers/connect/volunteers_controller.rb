class Connect::VolunteersController < Connect::BaseController
  before_action only: :confirmation { end_of_order "02.05.2018" }

  def index
    @volunteer = current_user.volunteer
  end

  def confirmation
    product = Records::Rj.new
    product.participants.build_from_user(current_user, lodging: has_lodging?)
    @order = Order.create!(user: current_user, product: product, case: :volunteer,
      lump_sum: price * 100, discount: discount, discount_amount: 100 * (Records::Rj::VOLUNTEER_TOTAL - price)
    )
  end

  private

  def price
    price = discount ? 0 : Records::Rj::VOLUNTEER_TOTAL
    price += 30 if has_lodging?
    return price
  end

  def discount
    @discount ||= Discount.find_by_code(params[:discount_code])
    discount_for_volunteer?(@discount) ? @discount : nil
  end

  def discount_for_volunteer?(discount)
    discount && discount.free? && discount.number == 1 && discount.product == "Records::Rj" && !discount.used
  end

  def has_lodging?
    params[:lodging].present?
  end

end
