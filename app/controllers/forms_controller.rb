class FormsController < ApplicationController
  before_action :check_if_active

  def new
    @custom_form = CustomForm.new(form, forms_path, view_context, email: true)
  end

  def create
    @custom_form = CustomForm.new(form, forms_path, view_context, email: true)
    @custom_form.assign_attributes(params[:custom_form])
    if @custom_form.save
      redirect_to signin_path, success: "Votre formulaire a été envoyé !"
    else
      render 'new'
    end
  end

  private

  def check_if_active
    redirect_to signin_path, error: "Le formulaire n'est plus disponible" unless form.active?
  end

  def form
    @form ||= Form.find_by(key: params[:key])
    raise ActionController::RoutingError.new('Not Found') unless @form
    return @form
  end

end
