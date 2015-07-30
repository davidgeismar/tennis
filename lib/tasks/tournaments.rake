namespace :tournaments do
  desc "Tranfers subscription fees from player wallets to tournament wallet for finished tournaments"
  task transfer_subcription_fees: :environment do
    subscription_error_ids  = []
    past_tournaments        = Tournament.where(funds_received: false).where('ends_on < :date', date: Date.today)

    past_tournaments.each do |tournament|
      confirmed_subscriptions = tournament.subscriptions.where(status: 'confirmed', funds_sent: false)

      confirmed_subscriptions.each do |subscription|
        succeeded = MangoPayments::Subscriptions::CreateTransferService.new(subscription).call

        unless succeeded
          subscription_error_ids << subscription.id
        end
      end

      payout_service = MangoPayments::Tournaments::CreatePayoutService.new(tournament)

      if subscription_error_ids.size > 0
        TechMailer.payout_error(tournament, subscription_error_ids).deliver_now
      elsif payout_service.call
        notification = Notification.create(
          user:       tournament.user,
          content:    "Fonds envoyés sur le compte bancaire du tournois #{tournament.name}",
          tournament: tournament
        )
      else
        TechMailer.payout_error(tournament, subscription_error_ids).deliver_now
      end
    end
  end
end
