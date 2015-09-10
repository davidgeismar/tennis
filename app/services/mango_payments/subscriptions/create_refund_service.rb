module MangoPayments
  module Subscriptions
    class CreateRefundService
      def initialize(subscription)
        @subscription = subscription
      end

      def call
        transaction       = @subscription.mangopay_transactions.create(status: 'pending', cgv: true, category: 'refund')
        mango_transaction = MangoPay::PayIn.refund(@subscription.mangopay_payin_id, { AuthorId: @subscription.user.mangopay_user_id })

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
