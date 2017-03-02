class Admin::Orders::LoginController < Admin::BaseController

  def index
    @table = OrderTable.new(self, Order.where(product_type: Records::Login))
    @table.respond
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    # TODO
  end

  def update
    # TODO
  end

  def destroy
    Order.find(params[:id]).destroy
		redirect_to admin_orders_login_index_path, success: "Commande supprimée"
  end

end
