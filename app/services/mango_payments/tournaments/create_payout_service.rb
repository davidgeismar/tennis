module MangoPayments
  module Tournaments
    class CreatePayoutService
      def initialize(tournament)
        @tournament = tournament
      end

      def call
        amount        = compute_total_amount
        amount_cents  = amount * 100
        fees_cents    = ((amount * 0.1) * 100).to_i
        transaction   = @tournament.create_mango_transaction(status: 'pending', category: 'payout')

        mango_transaction   = MangoPay::PayOut::BankWire.create(
          AuthorId:         @tournament.mangopay_user_id,
          DebitedWalletId:  @tournament.mangopay_wallet_id,
          DebitedFunds:     { Currency: 'EUR', Amount: amount_cents },
          Fees:             { Currency: 'EUR', Amount: fees_cents },
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

      def amount_by_type(fare_type)
        subscriptions = @tournament.subscriptions.where(status: 'confirmed', funds_sent: true, fare_type: fare_type)

        case fare_type
        when 'standard'
          subscriptions.count * @tournament.amount
        when 'young'
          subscriptions.count * @tournament.young_fare
        end
      end

      def compute_total_amount
        amount_by_type('young') + amount_by_type('standard')
      end
    end
  end
end
