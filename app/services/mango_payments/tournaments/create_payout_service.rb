module MangoPayments
  module Tournaments
    class CreatePayoutService
      def initialize(tournament)
        @tournament = tournament
      end

      def call
        amount        = total_amount
        amount_cents  = amount * 100
        transaction   = @tournament.create_mango_transaction(status: 'pending', category: 'payout')

        mango_transaction   = MangoPay::PayOut::BankWire.create(
          AuthorId:         @tournament.mangopay_user_id,
          DebitedWalletId:  @tournament.mangopay_wallet_id,
          DebitedFunds:     { Currency: 'EUR', Amount: amount_cents },
          Fees:             { Currency: 'EUR', Amount: 0 },
          BankAccountId:    @tournament.mangopay_bank_account_id,
          BankWireRef:      'Virement WeTennis',
        )

        transaction.update(
          archive:                  mango_transaction,
          mangopay_transaction_id:  mango_transaction['Id'],
          status:                   (['CREATED', 'SUCCEEDED'].include?(mango_transaction['Status']) ? 'success' : 'failed')
        )

        if transaction.status == 'success'
          @tournament.update(funds_received: true)
        else
          false
        end
      end

      private

      def total_amount
        total_amount_by_type('young') + total_amount_by_type('standard')
      end

      def amount_by_type(fare_type)
        subscriptions = @tournament.subscriptions.where(status: 'confirmed', funds_sent: true, fare_type: fare_type)

        case fare_type
        when 'standard'
          subscriptions.count * @tournament.amount
        when 'young'
          subscriptions.count * @tournament.young_fare
        end
      end
    end
  end
end
