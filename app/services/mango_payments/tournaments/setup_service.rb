module MangoPayments
  module Tournaments
    class SetupService
      def initialize(tournament)
        @tournament = tournament
      end

      def call
        user_service          = MangoPayments::Tournaments::CreateLegalUserService.new(@tournament)
        wallet_service        = MangoPayments::Tournaments::CreateWalletService.new(@tournament)
        bank_account_service  = MangoPayments::Tournaments::CreateBankAccountService.new(@tournament)

        return user_service.call &&
          wallet_service.call &&
          bank_account_service.call
      end
    end
  end
end
