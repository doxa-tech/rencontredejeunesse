class Admin::Orders::RjController < Admin::BaseController

  def index
    @table = OrderTable.new(self, Order.where(product_type: Records::Rj))
    @table.respond
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    Order.find(params[:id]).destroy
		redirect_to dashboard_path, success: "Commande supprimée"
  end

end
