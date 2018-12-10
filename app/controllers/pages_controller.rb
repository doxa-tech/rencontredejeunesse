class PagesController < ApplicationController
  # before_action :protect_with_password, only: :volunteer

  def home
  end

  def login
    @images_i = (0...8).to_a.shuffle
  end

  def vision
  end

  def highlights
    @images_i = (0..21).to_a.shuffle
  end

  def volunteer
    @volunteer = Volunteer.new
  end

  def rj2018
    render "pages/rj/2018"
  end

  def rj2019
    render "pages/rj/2019"
  end

  def volunteers
    @order_bundle = OrderBundle.find_by(key: "volunteers-rj-19")
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
