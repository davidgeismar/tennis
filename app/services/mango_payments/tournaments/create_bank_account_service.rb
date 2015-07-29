module MangoPayments
  module Tournaments
    class CreateBankAccountService
      def initialize(tournament)
        @tournament = tournament
      end

      def call
        mango_bank_account = MangoPay::BankAccount.create(@tournament.mangopay_user_id, {
          Type:         'IBAN',
          OwnerName:    @tournament.club_organisateur,
          OwnerAddress: @tournament.city,
          IBAN:         @tournament.iban,
          BIC:          @tournament.bic
        })

        @tournament.mangopay_bank_account_id = mango_bank_account['Id']
        @tournament.save
      end
    end
  end
end
