module MangoPayments
  module Subscriptions
    class CreatePayinService
      def initialize(user, amount)
        @user   = user
        @amount = amount
      end

      def call
        amount_cents = @amount * 100

        return MangoPay::PayIn::Card::Direct.create(
          AuthorId:             @user.mangopay_user_id,
          CardId:               @user.mangopay_card_id,
          CardType:             'CB_VISA_MASTERCARD',
          CreditedUserId:       @user.mangopay_user_id,
          CreditedWalletId:     @user.mangopay_wallet_id,
          DebitedFunds:         { Currency: 'EUR', Amount: amount_cents },  # TODO: change this.
          Fees:                 { Currency: 'EUR', Amount: 0 },             # TODO: change this.
          SecureModeReturnURL:  'https://wetennis.fr'
        )
      end
    end
  end
end
