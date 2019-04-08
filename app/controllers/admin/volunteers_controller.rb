class Admin::VolunteersController < Admin::BaseController

  def index
    authorize!
    bundle = OrderBundle.joins(:order_type).where(key: params[:key], order_types: { name: "volunteer" }).first
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
    @keys ||= OrderBundle.joins(:order_type).where(order_types: { name: "volunteer" }).pluck(:key)
  end

  def badge
    respond_to do |format|
      format.pdf do
        pdf = BadgePdf.new()
        send_data pdf.render, filename: "Badges.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  def badge_volunteer
    respond_to do |format|
      format.pdf do
        pdf = BadgeVolunteerPdf.new()
        send_data pdf.render, filename: "Badges_volunteer.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  def badge_prayer
    respond_to do |format|
      format.pdf do
        pdf = BadgePrayerPdf.new()
        send_data pdf.render, filename: "Badges_Prayer.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  private

  def select_field
    @select_field ||= Form::Field.joins(form: :order_types).where(name: "sector", field_type: "select_field", forms: { order_types: { name: "volunteer" }}).first
  end

end
