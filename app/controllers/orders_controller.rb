class OrdersController < Orders::BaseController
  before_action :check_if_not_signed_in, only: :destroy

  def destroy
    current_user.orders.find_by_order_id!(params[:id]).destroy
    redirect_to pending_connect_orders_path
  end

  def confirmed; end

  def canceled; end

  def uncertain; end

  def declined; end

end
