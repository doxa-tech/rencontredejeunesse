module Participants

  class Rj < Participant

    self.table_name = 'participants_rj'

    belongs_to :record, class_name: Records::Rj, foreign_key: "records_rj_id", inverse_of: :participants

  end

end
