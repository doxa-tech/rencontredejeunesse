class BundleValidator < ActiveModel::Validator

    def validate(record)
      @record = record
      @item_ids = record.registrants.map(&:item_id)
      @items_count = items_count
      @bundle_ids = bundle_ids
      if @items_count != 0
        if @bundle_ids.include?(nil)
          @record.errors.add(:base, "Un article n'est pas dans un bundle.")
        elsif bundle_ids.length > 1
          @record.errors.add(:base, "Les articles ne font pas partie du même bundle.")
        else
          validate_order_type
        end
      end
    end

    private

    def validate_order_type
      unless order_type.any?
        @record.errors.add(:base, "Un article n'est pas compatible.")
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
        bundle_id: @bundle_ids[0], name: "event")
    end

end