module Participants

  class Rj < Participant

    self.table_name = 'participants_rj'

    enum gender: [:male, :female]

    belongs_to :record, class_name: "Records::Rj", foreign_key: "records_rj_id", inverse_of: :participants

    validates :gender, presence: true, inclusion: { in: genders.keys }
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :birthday, presence: true
    validate :must_be_six_years_old

    def self.build_from_user(user)
      relation.build(user.as_json(only: [:gender, :firstname, :lastname, :birthday]))
    end

    def age
      unless birthday.nil?
        now = Date.today
        age = now.year - birthday.year
        age -= 1 if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
        return age
      end
    end

    private

    def must_be_six_years_old
      if birthday && (birthday.to_date + 6.years) > Date.today
        errors.add(:birthday, :too_young, age: "6")
      end
    end

  end

end
