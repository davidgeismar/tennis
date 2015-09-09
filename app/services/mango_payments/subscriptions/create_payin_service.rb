module MangoPayments
  module Subscriptions
    class CreatePayinService
      def initialize(subscription)
        @subscription = subscription
        @competition   = subscription.competition
        @tournament = subscription.competition.tournament
        @user         = subscription.user
      end

      def call
        amount_cents  = @tournament.amount * 100
        transfer      = @competition.transfers.create(status: 'pending', cgv: true, category: 'payin')

        transaction   = MangoPay::PayIn::Card::Direct.create(
          AuthorId:             @user.mangopay_user_id,
          CardId:               @user.mangopay_card_id,
          CardType:             'CB_VISA_MASTERCARD',
          CreditedUserId:       @user.mangopay_user_id,
          CreditedWalletId:     @user.mangopay_wallet_id,
          DebitedFunds:         { Currency: 'EUR', Amount: amount_cents },  # TODO: change this.
          Fees:                 { Currency: 'EUR', Amount: 0 },             # TODO: change this.
          SecureModeReturnURL:  'https://wetennis.fr'
        )

        transfer.update(
          archive:                  transaction,
          mangopay_transaction_id:  transaction['Id'],
          status:                   (transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )


        if transfer.status == 'success'
          @subscription.mangopay_payin_id = transaction['Id']
          @subscription.save
        else
          false
        end
      end
    end
  end
end
