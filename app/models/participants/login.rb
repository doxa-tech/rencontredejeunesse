module Participants

  class Login < Participant

    self.table_name = 'participants_login'

    enum gender: [:male, :female]

    belongs_to :record, class_name: "Records::Login", foreign_key: "records_login_id", inverse_of: :participants

    validates :gender, presence: true, inclusion: { in: genders.keys }
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :email, :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
    validates :age, presence: true # TODO

  end

end
