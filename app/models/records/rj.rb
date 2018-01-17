module Records

  class Rj < Record
    BED_PRICE = 30
    FEE = 5

    self.table_name = 'records_rj'

    has_one :order, as: :product

    has_many :participants, class_name: "Participants::Rj", foreign_key: "records_rj_id", inverse_of: :record
    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :participants, presence: true
    validates :group, length: { maximum: 70 }

    before_save :calculate_entries

    def calculate_amount
      return ((entries * Rj.ENTRY_PRICE) + (boy_beds + girl_beds) * BED_PRICE + FEE) * 100
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

    def calculate_entries
      self.entries = participants.size
    end
  end

end
