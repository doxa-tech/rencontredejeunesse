class Orders::PaymentsController < Orders::BaseController
  before_action :check_if_signed_in

  def show
    @payment = Payment.pending_on_postfinance.find_by(payment_id: params[:id])
    @user = @payment.order.user
    redirect_to root_path, error: "Vous n'êtes pas autorisé à faire ce paiement." if @user != current_user
  end

end
