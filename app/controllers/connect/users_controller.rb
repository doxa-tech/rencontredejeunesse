class Connect::UsersController < Connect::BaseController
  def show
    @current_partial = params[:partial] || "home"
  end

  def settings
    @current_partial = "settings"
    render 'show'
  end

  def shop
    @current_partial = "shop"
    render 'show'
  end

  def volunteer
    @current_partial = "volunteer"
    render 'show'
  end

  def goodies
    @current_partial = "goodies"
    render 'show'
  end
  
end
