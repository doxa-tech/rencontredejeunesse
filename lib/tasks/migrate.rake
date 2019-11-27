namespace :migrate do
  
  # After the migration is successful, drop the order_types table and remove the order_type_id from order_bundles.
  desc "Migrate the order_type association to an enum on order_bundle"
  task order_types: :environment do
    OrderBundle.each do |b|
      case b.order_type
      when "volunteer"
        order_type = "event"
        bundle_type = "volunteer"
      when "stand"
        order_type = "event"
        bundle_type = "stand"
      when "event"
        order_type = "event"
      when "regualr"
        order_type = "regular"
      end
      puts "Bundle #{b.name} set with order type `#{order_type}` and bundle type `#{bundle_type}`"
      b.update_attributes(order_type: order_type, bundle_type: bundle_type)
    end
    OrderType.each do |t|
      if t.form.present?
        t.order_bundles.each do |b|
          puts "Bundle #{b.name} set with form `#{t.form.name}`"
          b.update_attributes(form: t.form)
        end
      end
    end
  end

end