module Records

  class Rj < Record
    LODGING_PRICE = 30
    FEE = 5
    VOLUNTEER_PRICE = 50
    VOLUNTEER_FEE = 3
    VOLUNTEER_TOTAL = VOLUNTEER_PRICE + VOLUNTEER_FEE

    self.table_name = 'records_rj'

    has_many :participants, class_name: "Participants::Rj", foreign_key: "records_rj_id", inverse_of: :record do

      def build_from_user(user, params = {})
        build(user.as_json(only: [:gender, :firstname, :lastname, :birthday]).merge(params))
      end

    end

    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :participants, presence: true
    validates :group, length: { maximum: 70 }

    after_initialize :defaults
    after_validation :calculate_entries, :calculate_lodging

    def calculate_amount
      return ((entries * Rj.ENTRY_PRICE) + (man_lodging + woman_lodging) * LODGING_PRICE + FEE) * 100
    end

    def self.ENTRY_PRICE(date = Time.zone.today)
      if date < Date.new(2018, 2, 26)
        60
      elsif date < Date.new(2018, 4, 23)
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

    def calculate_lodging
      self.man_lodging = selected_participants.count { |p| p.gender == "male" && p.lodging }
      self.woman_lodging = selected_participants.count { |p| p.gender == "female" && p.lodging }
    end

  end

end
