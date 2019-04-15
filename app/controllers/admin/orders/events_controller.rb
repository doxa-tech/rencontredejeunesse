class Admin::Orders::EventsController < Admin::BaseController
  include OrdersHelper
  load_and_authorize(model: ::Orders::Event)

  def index
    @keys = OrderBundle.pluck(:key)
    @bundle = OrderBundle.find_by(key: params[:key])
    @events = @events.joins(:tickets).where(status: [:paid, :pending], items: { order_bundle_id: @bundle.id }).distinct if @bundle
    @count = @events.size
    @table = OrderTable.new(self, @events, search: true)
    @table.respond
  end

  def show
    @state = if @event.unpaid? || @event.delivered?
      "nok"
    elsif !@event.note.blank?
      "infos"
    else
      "ok"
    end
  end

  def edit
    @payment = Payment.new
  end

  def update
    @event.admin = true
    if @event.update_attributes(order_params)
      redirect_to admin_orders_event_path(@event), success: "Commande mise à jour"
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
