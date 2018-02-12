module Orders
  module Callbacks

    module Confirmation

      def self.rj(order)
        case order.case
        when "volunteer"
          Volunteer.find_by(user_id: order.user_id).update_attribute(:confirmed, true)
        end
      end

      def self.login(order)
      end

    end


  end
end
