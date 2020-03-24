class Connect::RefundsController <Connect::BaseController
  before_action :check_the_deadline

  def create
    @refund = Refund.new(refund_params)
    @refund.user = current_user
    @refund.order = @refund.orders.find_by(id: params[:refund][:order_id])
    if @refund.save
      RefundMailer.confirmation(@refund).deliver_now
      redirect_to connect_root_path, success: "Votre demande a été enregistrée"
    else
      render "connect/users/show"
    end
  end

  def check_the_deadline
    if Date.current > Refund::LIMIT_DATE
      redirect_to connect_root_path, "Cette page n'est plus disponible"
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:refund_type, :comment)
  end

end
