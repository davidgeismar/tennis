module MangoPayments
  module Subscriptions
    class CreatePayinService
      def initialize(subscription)
        @subscription = subscription
        @tournament   = subscription.tournament
        @user         = subscription.user
      end

      def call
        amount        = compute_amount
        amount_cents  = amount * 100
        transaction   = @subscription.mangopay_transactions.create(status: 'pending', cgv: true, category: 'payin')

        mango_transaction   = MangoPay::PayIn::Card::Direct.create(
          AuthorId:             @user.mangopay_user_id,
          CardId:               @user.mangopay_card_id,
          CardType:             'CB_VISA_MASTERCARD',
          CreditedUserId:       @user.mangopay_user_id,
          CreditedWalletId:     @user.mangopay_wallet_id,
          DebitedFunds:         { Currency: 'EUR', Amount: amount_cents },
          Fees:                 { Currency: 'EUR', Amount: 0 },
          SecureModeReturnURL:  'https://wetennis.fr'
        )

        transaction.update(
          archive:                  mango_transaction,
          mangopay_transaction_id:  mango_transaction['Id'],
          status:                   (mango_transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )


        if transaction.status == 'success'
          @subscription.mangopay_payin_id = mango_transaction['Id']
          @subscription.save
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
