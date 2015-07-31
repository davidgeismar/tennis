module MangoPayments
  module Users
    class CreateWalletService
      def initialize(user)
        @user = user
      end

      def call
        mango_wallet = MangoPay::Wallet.create(
          Owners:       [@user.mangopay_user_id],
          Description:  "Portefeuille joueur #{@user.full_name}",
          Currency:     'EUR' # TODO: change this.
        )

        @user.mangopay_wallet_id = mango_wallet['Id']
        @user.save
      end
    end
  end
end
