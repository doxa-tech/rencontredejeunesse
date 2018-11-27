class Orders::EventsController < Orders::BaseController
  before_action :check_if_not_signed_in
  before_action :closed, only: [:edit, :update, :confirmation]
  before_action :not_pending, only: :confirmation

  def new
    @order = Orders::Event.new
    @order.user = current_user
  end
  
  def create
    @order = Orders::Event.new(order_params)
    @order.user = current_user
    @order.pending = pending?
    if @order.save
      to_confirmation_step_or_pending
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    order.assign_attributes(order_params limited: order.limited)
    order.pending = pending?
    if order.save
      to_confirmation_step_or_pending
    else
      render 'edit'
    end
  end

  def confirmation
  end

  private

  def order_params(limited: false)
    attributes = [:conditions, :discount_code, registrants_attributes: [:id, :item_id]]
    attributes[-1][:registrants_attributes].push(:gender, :firstname, :lastname, :birthday, :_destroy) unless limited
    params.require(:orders_event).permit(attributes)
  end
  
end
