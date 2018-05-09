class Admin::Orders::RjController < Admin::BaseController
  include OrdersHelper
  load_and_authorize(model: Records::Rj)

  def index
    @count = Order.where(product_type: "Records::Rj", status: [5,9]).inject(0) { |sum, o| sum += o.product.entries }
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

  def users_export
    @orders = Order.where(product_type: "Records::Rj", status: [5,9]).includes(:product, :user)
  end

  def participants_export
    @participants = Participants::Rj.joins(record: :order).where(orders: { product_type: "Records::Rj", status: [5,9] })
  end

  private

  def order_params
    params.require(:order).permit(:note, product_attributes: [:id, :group,
      participants_attributes: [:id, :gender, :firstname, :lastname, :birthday, :lodging, :_destroy]
    ])
  end

end
