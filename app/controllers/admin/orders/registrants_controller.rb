class Admin::Orders::RegistrantsController < Admin::BaseController
  include OrdersHelper
  load_and_authorize

  def index
    @keys = OrderBundle.pluck(:key)
    @bundle = OrderBundle.find_by(key: params[:key])
    @registrants = @registrants.joins(:item, :order).where(orders: { status: :paid }, items: { order_bundle_id: @bundle.id }).distinct if @bundle
    @count = @registrants.size
    @table = RegistrantTable.new(self, @registrants, search: true)
    @table.respond
  end

  def show
    @order = @registrant.order
    @state = "ok"
    if @order.status != "paid" || @registrant.delivered
      @state = "nok"
    elsif !@order.note.blank?
      @state = "infos"
    end
  end


end
