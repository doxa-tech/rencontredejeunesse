module Records

  class Rj < Record
    BED_PRICE = 30
    FEE = 5

    self.table_name = 'records_rj'

    has_one :order, as: :product

    has_many :participants, class_name: Participants::Rj, foreign_key: "records_rj_id", inverse_of: :record
    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :group, length: { maximum: 70 }
    validates :entries, numericality: { only_integer: true, greater_than: 0 }
    validates :girl_beds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :boy_beds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validate :participants_cannot_be_greater_than_fourteen

    before_validation :defaults_for_beds, :calculate_entries

    def calculate_amount
      return ((entries * Rj.ENTRY_PRICE(self.created_at)) + (boy_beds + girl_beds) * BED_PRICE + FEE) * 100
    end

    def self.ENTRY_PRICE(date = Time.now)
      if date < Time.new(2017, 3, 27)
        50
      elsif date < Time.new(2017, 4, 24)
        65
      else
        80
      end
    end

    private

    def defaults_for_beds
      self.girl_beds ||= 0
      self.boy_beds ||= 0
    end

    def calculate_entries
      self.entries = 1 + participants.size
    end

    def participants_cannot_be_greater_than_fourteen
      if self.participants.size > 14
        errors.add(:participants, "Le nombre de participants ne doit pas dépasser 14 personnes.")
      end
    end
  end

end
