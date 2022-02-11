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
    begin
      render "pages/highlights/#{params[:year]}"
    rescue ActionView::MissingTemplate
      redirect_to root_path, error: "Année introuvable" 
    end
  end

  def volunteer
    @volunteer = Volunteer.new
  end

  def rj
    render "pages/rj" + request.path
  end

  def resources
    render "pages/resources"
  end

  def volunteers
    @order_bundle = OrderBundle.find_by(key: "volunteers-rj-20")
  end

  def contact
    @contact = Contact.new(contact_params)
    response = verify_captcha
    result = JSON.parse(response.body)
    if result["success"] && @contact.valid?
      MainMailer.contact(@contact).deliver_now
      redirect_to root_path, success: "Votre message a été envoyé"
    else
      redirect_to root_path, error: "Champs invalide(s)"
    end
  end

  def support
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @content = @markdown.render(render_to_string "support.md", layout: false)
    render layout: "markdown"
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :subject, :email, :message, :category)
  end

  def verify_captcha
    return RestClient.post('https://hcaptcha.com/siteverify', { 
      secret: Rails.application.secrets.hcaptcha_secret,
      response: params["g-recaptcha-response"],
      sitekey: Rails.application.secrets.hcaptcha_site_key
    })
  end

end
