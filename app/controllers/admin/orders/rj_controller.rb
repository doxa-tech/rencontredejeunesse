class Admin::Orders::RjController < Admin::BaseController
  load_and_authorize(model: Records::Rj)

  def index
    @count =  Order.where(product_type: "Records::Rj", status: [5,9]).inject(0) { |sum, o| sum += o.product.entries }
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

  def export
    @orders = Order.where(product_type: "Records::Rj").includes(:product, :user)
  end

  private

  def order_params
    params.require(:order).permit(:note, user_attributes: [
      :id, :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :birthday, :gender],
      product_attributes: [:id, :group, :girl_beds, :boy_beds,
      participants_attributes: [:id, :firstname, :lastname, :age, :_destroy]
    ])
  end

end
