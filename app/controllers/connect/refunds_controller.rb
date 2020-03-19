class Connect::RefundsController <Connect::BaseController

  def create
    @refund = Refund.new(refund_params)
    @refund.user = current_user
    if @refund.save
      RefundMailer.confirmation(@refund).deliver_now
      redirect_to connect_root_path, success: "Votre demande a été enregistrée"
    else
      render "connect/users/show"
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:order_id, :refund_type, :comment)
  end

end
