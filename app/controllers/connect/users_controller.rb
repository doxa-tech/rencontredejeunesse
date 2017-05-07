class Connect::UsersController < Connect::BaseController
  def show
    @current_partial = params[:partial] || "home"
  end

  def settings
    @current_partial = "settings"
    render 'show'
  end

  def volunteer
    @current_partial = "volunteer"
    render 'show'
  end
  
end
