module MangoPayments
  module Tournaments
    class CreateWalletService
      def initialize(tournament)
        @tournament = tournament
      end

      def call
        mango_wallet = MangoPay::Wallet.create(
          Owners:       [@tournament.mangopay_user_id],
          Description:  "Portefeuille tournois #{@tournament.name}",
          Currency:     'EUR' # TODO: change this.
        )

        @tournament.mangopay_wallet_id = mango_wallet['Id']
        @tournament.save
      end
    end
  end
end
