class Admin::Orders::RjController < Admin::BaseController

  def index
    @table = OrderTable.new(self, Order.where("product_type = ? AND status NOTNULL", "Records::Rj"), search: true)
    @table.respond
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.product = Records::Rj.new
    if @order.update_attributes(order_params)
      redirect_to admin_orders_rj_path(@order), success: "Commande mise à jour"
    else
      render 'edit'
    end
  end

  def destroy
    Order.find(params[:id]).destroy
		redirect_to admin_orders_rj_index_path, success: "Commande supprimée"
  end

  private

  def order_params
    params.require(:order).permit(:note, user_attributes: [
      :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :birthday, :gender],
      product_attributes: [:group, :girl_beds, :boy_beds,
      participants_attributes: [:firstname, :lastname, :age, :_destroy]
    ])
  end

end
