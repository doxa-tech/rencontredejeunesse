class Admin::CheckinController < Admin::BaseController

  def index
  end

  def show
    @order = Order.find_by(human_id: params[:id])
  end

  def create
    params[:human_id].upcase!
    @order = Order.find_by(human_id: params[:human_id])
    unless @order.nil?
      redirect_to admin_checkin_path(params[:human_id])
    else
      flash.now[:error] = "Commande non trouvé !"
      render 'index'
    end
  end

end
