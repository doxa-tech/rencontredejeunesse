class PagesController < ApplicationController
  before_action :protect_with_password, only: :volunteer

  def home
  end

  def login
  end

  def vision
  end

  def volunteer
  end

  def rj2018
    render "pages/rj/2018"
  end

  def contact
    @contact = Contact.new(contact_params)
    if @contact.valid?
      MainMailer.contact(@contact).deliver_now
      redirect_to root_path, success: "Votre message a été envoyé"
    else
      redirect_to root_path, error: "Champs invalide(s)"
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :subject, :email, :message)
  end

end
