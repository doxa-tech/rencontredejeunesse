module ExceptionsHandler

  extend ActiveSupport::Concern

  included do

    rescue_from Adeia::AccessDenied do |exception|
      respond_to do |format|
        format.html do
          redirect_to connect_root_path, error: "Accès non authorisé"
        end
        format.all { head :forbidden }
      end
    end

    rescue_from Adeia::LoginRequired do |exception|
      respond_to do |format|
        format.html do
          redirect_to "/signin", error: "Veuillez vous connecter"
        end
        format.all { head :unauthorized }
      end
    end

  end

end
