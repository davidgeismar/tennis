class TransfersController < ApplicationController
  skip_after_action :verify_authorized

  # transfers have a credited_user_id and a author_id stored in json "archive"
  # subscription is created here at the end of the method
  # is called when user pays for tournament
  def create
    tournament = Tournament.find(params[:tournament_id])
    transfer   = tournament.transfers.create(status: 'pending', cgv: true, category: 'payin')

    current_user.update(mangopay_card_id: params[:card_id])

    service = MangoPayments::Subscriptions::CreatePayinService.new(current_user, tournament.amount)
    payin   = service.call

    transfer.archive                  = payin
    transfer.mangopay_transaction_id  = payin["Id"]

    if payin['Status'] == 'SUCCEEDED'
      transfer.status = 'success'
      transfer.save

      subscription = Subscription.create(user: current_user, tournament: tournament)

      notification = Notification.create(
        user:       subscription.tournament.user,
        content:    "#{subscription.user.full_name} a demandé à s'inscrire à #{subscription.tournament.name}",
        tournament: subscription.tournament
      )

      redirect_to new_subscription_disponibility_path(subscription)
    else
      transfer.status = 'failed'
      transfer.save

      flash[:alert] = 'Un problème est survenu lors du paiement. Merci de bien vouloir réessayer plus tard.'
      redirect_to root_path
    end
  end
end
