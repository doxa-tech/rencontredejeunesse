class Admin::Forms::CompletedFormsController < Admin::BaseController
  load_and_authorize(model: Form::CompletedForm)

  def index
    @keys = Form.pluck(:key)
    @form = Form.find_by(key: params[:key])
    @completed_forms = Form::CompletedForm.where(form: @form) if @form
    @table = CompletedFormTable.new(self, @completed_forms, search: true, truncate: false)
    @table.respond    
  end

  def show
  end

  def destroy
    @completed_form.destroy
		redirect_to admin_forms_completed_forms_path, success: "Formulaire supprimé"
  end

end
