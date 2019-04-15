class Admin::Orders::RegistrantsController < Admin::BaseController
  include OrdersHelper
  load_and_authorize except: :export

  def index
    @keys = OrderBundle.pluck(:key)
    @registrants = filter_by_key(@registrants, params[:key])
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
    render "show", layout: "checkin"
  end

  def export
    @registrants = authorize_and_load_records!
    @registrants = filter_by_key(@registrants, params[:key]).includes(:item, order: :user)
  end

  private

  def filter_by_key(collection, key)
    @bundle = OrderBundle.find_by(key: params[:key])
    if @bundle
      collection = collection.joins(:item, :order).where(orders: { status: :paid }, items: { order_bundle_id: @bundle.id }).distinct
    end
    return collection
  end

end
