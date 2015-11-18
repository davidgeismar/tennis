module MangoPayments
  module Subscriptions
    class BaseService
      protected

      def amount
        unless @amount
          case @subscriptions.first.fare_type
          when 'standard'
            @amount = @subscriptions.first.tournament.amount
          when 'young'
            @amount = @subscriptions.first.tournament.young_fare
          end
        end

        @amount
      end
    end
  end
end
