module MangoPayments
  module Subscriptions
    class CreateTransferService
      def initialize(subscription)
        @subscription = subscription
        @tournament   = subscription.tournament
        @user         = subscription.user
      end

      def call
        amount_cents  = @tournament.amount * 100
        transfer      = @tournament.transfers.create(status: 'pending', category: 'transfer')

        transaction   = MangoPay::Transfer.create(
          AuthorId:         @user.mangopay_user_id,
          DebitedWalletId:  @user.mangopay_wallet_id,
          CreditedUserId:   @tournament.mangopay_user_id,
          CreditedWalletId: @tournament.mangopay_wallet_id,
          DebitedFunds:     { Currency: 'EUR', Amount: amount_cents },  # TODO: change this.
          Fees:             { Currency: 'EUR', Amount: 0 },             # TODO: change this.
        )

        transfer.update(
          archive:                  transaction,
          mangopay_transaction_id:  transaction['Id'],
          status:                   (transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
        )

        if transfer.status == 'success'
          @subscription.update(funds_sent: true)
        else
          false
        end
      end
    end
  end
end


 # mangopay_user_id: "7855702",
 # mangopay_wallet_id: "7855703",
 # mangopay_bank_account_id: "7855705",


 #  SQL (0.6ms)  UPDATE "transfers" SET "mangopay_transaction_id" = $1, "status" = $2, "archive" = $3, "updated_at" = $4 WHERE "transfers"."id" = $5  [["mangopay_transaction_id", 7856752], ["status", "failed"], ["archive", "{\"Id\":\"7856752\",\"Tag\":null,\"CreationDate\":1438291652,\"AuthorId\":\"7855702\",\"CreditedUserId\":\"7855702\",\"DebitedFunds\":{\"Currency\":\"EUR\",\"Amount\":2000},\"CreditedFunds\":{\"Currency\":\"EUR\",\"Amount\":2000},\"Fees\":{\"Currency\":\"EUR\",\"Amount\":0},\"Status\":\"FAILED\",\"ResultCode\":\"001002\",\"ResultMessage\":\"Author is not the wallet owner\",\"ExecutionDate\":null,\"Type\":\"TRANSFER\",\"Nature\":\"REGULAR\",\"DebitedWalletId\":\"7855725\",\"CreditedWalletId\":\"7855703\"}"], ["updated_at", "2015-07-30 21:28:53.695035"], ["id", 17]]
 #   (5.0ms)  COMMIT
