class Connect::RefundsController <Connect::BaseController

  def create
    @refund = Refund.new(refund_params)
    if @refund.save
      redirect_to connect_path, success: "Votre demande a été enregistrée"
    else
      render "connect/users/show"
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:order, :refund_type, :comment)
  end

end
