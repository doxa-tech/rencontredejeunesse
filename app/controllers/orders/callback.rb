module Callback

  module Confirmation

    def self.rj
      VolunteerForm.new(session[:volunteer_params]).save(@order.user) if session[:volunteer_params]
    end

  end


end
