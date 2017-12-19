module Participants

  class Login < Participant

    self.table_name = 'participants_login'

    belongs_to :record, class_name: "Records::Login", foreign_key: "records_login_id", inverse_of: :participants

    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :age, presence: true # TODO

  end

end
