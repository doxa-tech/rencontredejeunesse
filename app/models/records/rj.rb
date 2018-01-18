module Records

  class Rj < Record
    LODGING_PRICE = 30
    FEE = 5

    self.table_name = 'records_rj'

    has_one :order, as: :product

    has_many :participants, class_name: "Participants::Rj", foreign_key: "records_rj_id", inverse_of: :record
    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :participants, presence: true
    validates :group, length: { maximum: 70 }

    after_initialize :defaults
    before_save :calculate_entries, :calculate_lodging

    # TODO: beds
    def calculate_amount
      return ((entries * Rj.ENTRY_PRICE) + (man_lodging + woman_lodging) * LODGING_PRICE + FEE) * 100
    end

    def self.ENTRY_PRICE(date = Time.now)
      if date < Time.new(2018, 2, 25)
        60
      elsif date < Time.new(2018, 4, 22)
        75
      else
        90
      end
    end

    private

    def defaults
      self.entries ||= 1
      self.man_lodging ||= 0
      self.woman_lodging ||= 0
    end

    def calculate_entries
      self.entries = participants.size
    end

    def calculate_lodging
      self.man_lodging = participants.count { |p| p.gender == "male" && p.lodging }
      self.woman_lodging = participants.count { |p| p.gender == "female" && p.lodging }
    end
  end

end
