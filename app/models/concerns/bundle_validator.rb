class BundleValidator < ActiveModel::Validator

    VALIDATIONS = {
      regular: [:uniqueness_of_bundle, :name_of_order_type, :availability_of_bundle],
      event: [:presence_of_bundle, :uniqueness_of_bundle, :name_of_order_type, :availability_of_bundle]
    }

    def validate(record)
      @record = record
      @item_ids = record.registrants.map(&:item_id)
      @items_count = items_count
      @bundle_ids = bundle_ids
      if @items_count != 0
        VALIDATIONS[@record.order_type].each do |v|
          send(v)
        end
      end
    end

    private

    def presence_of_bundle
      if @bundle_ids.include?(nil)
        @record.errors.add(:base, "Un article n'est pas dans un bundle.")
      end
    end

    def uniqueness_of_bundle
      if @bundle_ids.length > 1
        @record.errors.add(:base, "Les articles ne font pas partie du même bundle.")
      end
    end

    def name_of_order_type
      unless order_type.any?
        @record.errors.add(:base, "Un article n'est pas compatible.")
      end
    end

    def availability_of_bundle
      bundle = OrderBundle.find_by(id: @bundle_ids[0])
      if bundle && !bundle.open && !@record.limited
        @record.errors.add(:base, "Les articles ne sont pas disponibles.")
      end
    end

    def items_count
      Item.where(id: @item_ids).count
    end

    def bundle_ids
      Item.where(id: @item_ids).pluck("DISTINCT order_bundle_id")
    end

    def order_type
      OrderType.joins(:order_bundles)
        .joins("LEFT JOIN order_types supertypes ON supertypes.id = order_types.supertype_id")
        .where("order_bundles.id = :bundle_id AND (order_types.name = :name OR supertypes.name = :name)", 
        bundle_id: @bundle_ids[0], name: @record.order_type)
    end

end