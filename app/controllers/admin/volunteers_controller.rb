class Admin::VolunteersController < Admin::BaseController

  def index
    authorize!
    bundle = OrderBundle.where(key: params[:key], order_type: "volunteer").first
    value = sectors.index(params[:sector])
    @orders = OptionOrder.where(order_bundle: bundle)
    @orders = @orders.joins(completed_form: :completed_fields).where(
        completed_forms: { completed_fields: { field_id: select_field.id, value: value.to_s }}) if value
    @table = OptionOrderTable.new(self, @orders, search: true, truncate: false)
    @table.respond
  end

  def show
    authorize!
    @option_order = OptionOrder.find(params[:id])
    render "admin/option_orders/show"
  end

  helper_method :sectors, :keys
  def sectors
    @sectors ||= select_field.options.values.flatten
    t(@sectors, scope: CustomForm::I18N_PATH + ".select")
  end

  def keys
    @keys ||= OrderBundle.where(order_type: "volunteer").pluck(:key)
  end

  private

  def select_field
    @select_field ||= Form::Field.joins(form: :order_bundle).where(name: "sector", field_type: "select_field", forms: { order_bundles: { bundle_type: "volunteer" }}).first
  end

end
