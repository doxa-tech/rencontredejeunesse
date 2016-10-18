module Callbacks

  module Confirmation

    def self.rj(params, user)
      VolunteerForm.new(params).save(user) if params
    end

  end


end
