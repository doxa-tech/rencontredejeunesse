class Admin::VolunteersController < Admin::BaseController

  def index
    authorize!
    @orders = bundle ? OptionOrder.where(order_bundle: bundle) : OptionOrder.all
    if select_field && params[:sector].present?
      @orders = @orders.joins(completed_form: :completed_fields).where(
          completed_forms: { completed_fields: { field: select_field, value: sectors.index(params[:sector]).to_s }})
    end
    @table = OptionOrderTable.new(self, @orders, search: true, truncate: false)
    @table.respond
  end

  def show
    authorize!
    @option_order = OptionOrder.find(params[:id])
    render "admin/option_orders/show"
  end

  helper_method :sectors, :keys
  def keys
    @keys ||= OrderBundle.where(bundle_type: "volunteer").pluck(:key)
  end

  def sectors
    @sectors ||= select_field ? select_field.options.map { |v| v.respond_to?(:values) ? v.values : v }.flatten : []
  end

  private

  def bundle
    @bundle ||= OrderBundle.find_by(key: params[:key], bundle_type: "volunteer")
  end

  def select_field
    if bundle
      @select_field ||= 
        Form::Field.find_by(name: "sector", field_type: "select_field", form_id: bundle.form_id)
    end
  end

end
