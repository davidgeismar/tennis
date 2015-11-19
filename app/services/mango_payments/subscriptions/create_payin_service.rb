module MangoPayments
  module Subscriptions
    class CreatePayinService < MangoPayments::Subscriptions::BaseService
      def initialize(subscriptions, tournament, current_user)
        @subscriptions = subscriptions
        @tournament   =   tournament
        @user         = current_user
      end

      def call
        # amount est défini dans le bas_service
        amount_cents  = amount * 100 * @subscriptions.count
        # les 55c de commission par transaction
        fees_cents    = Settings.tournament.fees_cents
        total_cents   = amount_cents + fees_cents

        # je prend chacune des subscription et je crée un mangopay transactions
        transactions   = []

        @subscriptions.each do |subscription|
         transactions << subscription.mangopay_transactions.new(status: 'pending', cgv: true, category: 'payin')
        end

          #paiement
        mango_transaction = MangoPay::PayIn::Card::Direct.create(
          AuthorId:             @user.mangopay_user_id,
          CardId:               @user.mangopay_card_id,
          CardType:             'CB_VISA_MASTERCARD',
          CreditedUserId:       @user.mangopay_user_id,
          CreditedWalletId:     @user.mangopay_wallet_id,
          DebitedFunds:         { Currency: 'EUR', Amount: total_cents },
          Fees:                 { Currency: 'EUR', Amount: fees_cents },
          SecureModeReturnURL:  'https://wetennis.fr'
        )


        subscriptions = []
        transactions.each do |transaction|
          # j'update le statut de chacune des transaction
            transaction.assign_attributes(
            archive:                  mango_transaction,
            mangopay_transaction_id:  mango_transaction['Id'],
            status:                   (mango_transaction['Status'] == 'SUCCEEDED' ? 'success' : 'failed')
          )
          if transaction.status == 'success'
            transaction.subscription.mangopay_payin_id = mango_transaction['Id']
            # je save la transaction correspondante
            subscription = transaction.subscription.save
            subscriptions << subscription
          else
            false
          end
        end
        if subscriptions.blank?
          return false
        else
          return subscriptions
          binding.pry
        end
      end
    end
  end
end
