module Orders
  module Callbacks

    module Confirmation

      def self.rj(params, user)
        VolunteerForm.new(params).save(user) if params
      end

      def self.login(params, user)
      end

    end


  end
end
