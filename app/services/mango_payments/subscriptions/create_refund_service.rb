module MangoPayments
  module Subscriptions
    class CreateRefundService
      def initialize(subscription)
        @subscription = subscription
      end

      def call
        transfer    = @subscription.competition.transfers.create(status: 'pending', cgv: true, category: 'refund')
        transaction = MangoPay::PayIn.refund(@subscription.mangopay_payin_id, { AuthorId: @subscription.user.mangopay_user_id })

        transfer.update(
          archive:                  transaction,
          mangopay_transaction_id:  transaction['Id'],
          status:                   (transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )

        return transfer.status == 'success'
      end
    end
  end
end
