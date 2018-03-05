class Admin::DiscountsController < Admin::BaseController
  load_and_authorize

  def index
    @table = Table.new(self, Discount)
		@table.respond
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to admin_discounts_path, success: "Code promotionel créé"
    else
      render 'new'
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    if @discount.orders.any?
      flash[:error] = "Code promotionel utilisé"
    else
      @discount.destroy
      flash[:success] = "Code promotionel supprimé"
    end
    redirect_to admin_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:category, :product, :reduction, :number)
  end
end
