module MangoPayments
  module Subscriptions
    class CreateTransferService
      def initialize(subscription)
        @subscription = subscription
        @tournament   = subscription.tournament
        @user         = subscription.user
      end

      def call
        amount        = compute_amount
        amount_cents  = amount * 100
        transaction   = @subscription.mangopay_transactions.create(status: 'pending', category: 'transfer')

        mango_transaction   = MangoPay::Transfer.create(
          AuthorId:         @user.mangopay_user_id,
          DebitedWalletId:  @user.mangopay_wallet_id,
          CreditedUserId:   @tournament.mangopay_user_id,
          CreditedWalletId: @tournament.mangopay_wallet_id,
          DebitedFunds:     { Currency: 'EUR', Amount: amount_cents },
          Fees:             { Currency: 'EUR', Amount: 0 },
        )

        transaction.update(
          archive:                  mango_transaction,
          mangopay_transaction_id:  mango_transaction['Id'],
          status:                   (mango_transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )

        if transaction.status == 'success'
          @subscription.update(funds_sent: true)
        else
          false
        end
      end

      private

      def compute_amount
        case @subscription.fare_type
        when 'standard'
          @tournament.amount
        when 'young'
          @tournament.young_fare
        end
      end
    end
  end
end
