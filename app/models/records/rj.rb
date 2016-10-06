module Records

  class Rj < Record
    BED_PRICE = 20
    FEE = 5

    self.table_name = 'records_rj'

    has_one :order, as: :product

    validates :group, presence: true, length: { maximum: 70 }
    validates :entries, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :girl_beds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :boy_beds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    before_validation :defaults_for_beds

    def calculate_amount
      return ((entries * entry_price) + (boy_beds + girl_beds) * BED_PRICE + FEE) * 100
    end

    private

    def entry_price
      50
    end

    def defaults_for_beds
      self.girl_beds ||= 0
      self.boy_beds ||= 0
    end
  end

end
