class Admin::OrdersController < Admin::BaseController

  def login
    @table = OrderTable.new(self, Order.where(product_type: Records::Login))
    @table.respond
  end

  def rj
    @table = OrderTable.new(self, Order.where(product_type: Records::Rj))
    @table.respond
  end

  def destroy
		Order.find(params[:id]).destroy
		redirect_to dashboard_path, success: "Commande supprimée"
	end
end
