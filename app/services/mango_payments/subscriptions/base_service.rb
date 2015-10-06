module MangoPayments
  module Subscriptions
    class BaseService
      protected

      def amount
        unless @amount
          case @subscription.fare_type
          when 'standard'
            @amount = @subscription.tournament.amount
          when 'young'
            @amount = @subscription.tournament.young_fare
          end
        end

        @amount
      end
    end
  end
end
