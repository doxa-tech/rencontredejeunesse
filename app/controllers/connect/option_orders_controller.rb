class Connect::OptionOrdersController < Connect::BaseController

  def index
    @orders = current_user.option_orders
  end

  def show
    @order = OptionOrder.find(params[:id])
  end

end
