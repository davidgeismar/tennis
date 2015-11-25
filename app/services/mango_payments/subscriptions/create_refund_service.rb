module MangoPayments
  module Subscriptions
    class CreateRefundService < MangoPayments::Subscriptions::BaseService
      def initialize(subscription)
        @subscription = subscription
      end

      def call
        amount_cents      = amount * 100
        transaction       = @subscription.mangopay_transactions.create(status: 'pending', cgv: true, category: 'refund')
        # potential partial payment
        mango_transaction = MangoPay::PayIn.refund(
          @subscription.mangopay_payin_id,
          {
            AuthorId:     @subscription.user.mangopay_user_id,
            DebitedFunds: { Currency: 'EUR', Amount: amount_cents },
            Fees:         { Currency: 'EUR', Amount: 0 }
          }
        )

        transaction.update(
          archive:                  mango_transaction,
          mangopay_transaction_id:  mango_transaction['Id'],
          status:                   (mango_transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )

        return transaction.status == 'success'
      end
    end
  end
end
