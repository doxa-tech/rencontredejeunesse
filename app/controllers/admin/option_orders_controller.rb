class Admin::OptionOrdersController < Admin::BaseController
  load_and_authorize

  def index
    @keys = OrderBundle.pluck(:key)
    @bundle = OrderBundle.find_by(key: params[:key])
    @option_orders = @option_orders.where(order_bundle: @bundle) if @bundle
    @table = OptionOrderTable.new(self, @option_orders, search: true)
    @table.respond    
  end

  def show
  end

  def destroy
    @option_order.destroy
		redirect_to admin_option_orders_path, success: "Commande supprimée"
  end

end
