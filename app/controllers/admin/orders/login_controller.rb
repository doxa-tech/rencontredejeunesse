class Admin::Orders::LoginController < Admin::BaseController
  include OrdersHelper
  load_and_authorize(model: Records::Login)

  def index
    @count = Order.where(product_type: "Records::Login", status: [5,9]).inject(0) { |sum, o| sum += o.product.entries }
    @table = OrderTable.new(self, Order.where("product_type = ? AND status NOTNULL", "Records::Login"), search: true)
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
