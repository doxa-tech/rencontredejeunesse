module Orders
  module Callbacks

    module Confirmation

      def self.rj(order)
        case order.case
        when "volunteer"
          volunteer = Volunteer.find_by(user_id: order.user_id)
          volunteer.update_attribute(:confirmed, true)
          Admin::VolunteerMailer.confirmed(volunteer)
        end
      end

      def self.login(order)
      end

    end


  end
end
