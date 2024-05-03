class Admin::Orders::EventsController < Admin::BaseController
  include OrdersHelper
  load_and_authorize(model: ::Orders::Event)

  def index
    if params[:redirect_key]
      redirect_to "/admin/orders/#{params[:redirect_key]}/events"
    end

    @keys = OrderBundle.where(active: true).pluck(:key)
    @bundle = OrderBundle.find_by(key: params[:bundle_key])
    @events = @events.joins(tickets: :order_bundle).where(items: { order_bundles: { active: true }})
    @events = @events.where(items: { order_bundle_id: @bundle.id }).distinct if @bundle
    @events = @events.distinct
    @count = @events.where(status: :paid).size
    @table = OrderTable.new(self, @events, search: true)
    @table.respond
  end

  def show
    @state = if !@event.paid? || @event.delivered?
      "red"
    elsif !@event.note.blank?
      "orange"
    else
      "green"
    end
  end

  def edit
    @payment = Payment.new
  end

  def update
    @event.admin = true
    if @event.update_attributes(order_params)
      redirect_to admin_orders_event_path(id: @event.id), success: "Commande mise à jour"
    else
      @payment = Payment.new
      render 'edit'
    end
  end

  def destroy
    @event.destroy
		redirect_to admin_orders_events_path, success: "Commande supprimée"
  end

  private

  def order_params
    params.require(:orders_event).permit(:note, registrants_attributes: [:id, :gender, :firstname, :lastname, :birthday, :item_id, :_destroy])
  end

end
