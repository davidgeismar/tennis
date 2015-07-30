module MangoPayments
  module Subscriptions
    class CreateTransferService
      def initialize(subscription)
        @subscription = subscription
        @tournament   = subscription.tournament
        @user         = subscription.user
      end

      def call
        amount_cents  = @tournament.amount * 100
        transfer      = @tournament.transfers.create(status: 'pending', category: 'transfer')

        transaction   = MangoPay::Transfer.create(
          AuthorId:         @tournament.mangopay_user_id,
          DebitedWalletId:  @user.mangopay_walled_id,
          CreditedUserId:   @tournament.mangopay_user_id,
          CreditedWalletId: @tournament.mangopay_walled_id,
          DebitedFunds:     { Currency: 'EUR', Amount: amount_cents },  # TODO: change this.
          Fees:             { Currency: 'EUR', Amount: 0 },             # TODO: change this.
        )

        transfer.update(
          archive:                  transaction,
          mangopay_transaction_id:  transaction['Id']
          status:                   (transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )

        if transfer.status == 'success'
          @subscription.update(funds_sent: true)
        else
          false
        end
      end
    end
  end
end
