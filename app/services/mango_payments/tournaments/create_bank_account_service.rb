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
          OwnerAddress: {
                          AddressLine1: @tournament.address,
                          City: @tournament.city,
                          Region: "Ile-de-France",
                          PostalCode: @tournament.postcode,
                          Country: "FR"
                        },

          IBAN:         @tournament.iban,
          BIC:          @tournament.bic
        })

        @tournament.mangopay_bank_account_id = mango_bank_account['Id']
        @tournament.save
      end
    end
  end
end
