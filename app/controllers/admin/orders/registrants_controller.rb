class Admin::Orders::RegistrantsController < Admin::BaseController
  include OrdersHelper
  load_and_authorize except: :export

  def index
    if params[:redirect_key]
      redirect_to "/admin/orders/#{params[:redirect_key]}/registrants"
    end

    @keys = OrderBundle.where(active: true).pluck(:key)
    @registrants = filter_by_key(@registrants, params[:key])
    @count = @registrants.joins(:order).where(orders: { status: [:paid]}).size
    @table = RegistrantTable.new(self, @registrants, search: true)
    @table.respond
  end

  def show
    @order = @registrant.order
    @state = if !@order.paid? || @registrant.delivered?
      "red"
    elsif !@order.note.blank?
      "orange"
    else
      "green"
    end
    render "show", layout: "checkin"
  end

  def export
    @registrants = authorize_and_load_records!
    @registrants = filter_by_key(@registrants, params[:key])
    @registrants.joins(:order).where(orders: { status: [:paid, :pending]}).includes(:item, order: :user)
  end

  private

  def filter_by_key(collection, key)
    @bundle = OrderBundle.find_by(key: params[:bundle_key])
    collection = collection.joins(item: :order_bundle).where(items: { order_bundles: { active: true }})
    collection = collection.where(items: { order_bundle_id: @bundle.id }).distinct if @bundle
    return collection
  end

end
