module Participants

  class Rj < Participant

    self.table_name = 'participants_rj'

    belongs_to :record, class_name: "Records::Rj", foreign_key: "records_rj_id", inverse_of: :participants

    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :age, presence: true # TODO

  end

end
