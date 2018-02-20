module Records

  class Login < Record
    FEE = 2
    ENTRY_PRICE = 25

    self.table_name = 'records_login'

    has_one :order, as: :product

    has_many :participants, class_name: "Participants::Login", foreign_key: "records_login_id", inverse_of: :record do

      def build_from_user(user)
        build(user.as_json(only: [:gender, :firstname, :lastname, :email], methods: :age))
      end

    end

    accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: :all_blank

    validates :participants, presence: true
    validates :group, length: { maximum: 70 }

    after_initialize :defaults
    before_validation :calculate_entries

    def calculate_amount
      return (entries * ENTRY_PRICE + FEE) * 100
    end

    def self.ENTRY_PRICE
      ::ENTRY_PRICE
    end

    private

    def defaults
      self.entries ||= 1
    end

    def calculate_entries
      self.entries = participants.size
    end

  end

end
