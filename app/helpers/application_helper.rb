module ApplicationHelper

  def display_price(price)
    "#{price / 100} CHF"
  end

  def options_for_enum(record, enum)
    model = record.class
    pluralized_enum = enum.to_s.pluralize
    options_for_select(model.send(pluralized_enum).map {|k, v| [ t("#{model.model_name.i18n_key}.#{pluralized_enum}.#{k}"), k ]}, record.send(enum))
  end

  def active_class(link_path, *classes)
    classes = classes.join(" ")
    current_page?(link_path) ? "active #{classes}" : classes
  end

  def hidden_if_destroyed(object)
    return "display: none;" if object.marked_for_destruction?
  end

  def link_to_rj_order(text, start:, term:)
    span = Date.parse(start)..Date.parse(term)
    css_class = "disabled" unless span === Time.zone.today
    link_to text, new_orders_rj_path, class: css_class
  end

end
