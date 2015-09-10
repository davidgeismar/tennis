module MangoPayments
  module Subscriptions
    class CreatePayinService < MangoPayments::Subscriptions::BaseService
      def initialize(subscription)
        @subscription = subscription
        @tournament   = subscription.tournament
        @user         = subscription.user
      end

      def call
        amount_cents  = amount * 100
        fees_cents    = ((amount * 0.1) * 100).to_i
        total_cents   = amount_cents + fees_cents
        transaction   = @subscription.mangopay_transactions.create(status: 'pending', cgv: true, category: 'payin')

        mango_transaction   = MangoPay::PayIn::Card::Direct.create(
          AuthorId:             @user.mangopay_user_id,
          CardId:               @user.mangopay_card_id,
          CardType:             'CB_VISA_MASTERCARD',
          CreditedUserId:       @user.mangopay_user_id,
          CreditedWalletId:     @user.mangopay_wallet_id,
          DebitedFunds:         { Currency: 'EUR', Amount: total_cents },
          Fees:                 { Currency: 'EUR', Amount: fees_cents },
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
    end
  end
end
