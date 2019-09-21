class FormsController < ApplicationController

  def new
    @custom_form = CustomForm.new(form, forms_path, view_context)
  end

  def create
    @custom_form = CustomForm.new(form, option_orders_path, view_context)
    @custom_form.assign_attributes(params[:custom_form])
    if @custom_form.save
      redirect_to root_path, success: "Votre formulaire a été envoyé !"
    else
      render 'new'
    end
  end

  private

  def form
    @form ||= Form.find_by(key: params[:key])
    redirect_to root_path, error: "Ce formulaire n'existe pas" if @form.nil?
    return @form
  end

end
