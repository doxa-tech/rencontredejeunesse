module Records

  class Login < Record
    FEE = 2
    ENTRY_PRICE = 25

    self.table_name = 'records_login'

    has_one :order, as: :product

    has_many :participants, class_name: "Participants::Login", foreign_key: "records_login_id", inverse_of: :record
    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :participants, presence: true
    validates :group, length: { maximum: 70 }

    before_save :calculate_entries

    def calculate_amount
      return (entries * ENTRY_PRICE + FEE) * 100
    end

    private

    def calculate_entries
      self.entries = participants.size
    end

  end

end
