class TransfersController < ApplicationController
  skip_after_action :verify_authorized

  # transfers have a credited_user_id and a author_id stored in json "archive"
  # subscription is created here at the end of the method
  # is called when user pays for tournament
  def create
    current_user.update(mangopay_card_id: params[:card_id])

    tournament    = Tournament.find(params[:tournament_id])
    subscription  = Subscription.new(user: current_user, tournament: tournament)
    service       = MangoPayments::Subscriptions::CreatePayinService.new(subscription)

    if service.call
      subscription = Subscription.create(user: current_user, tournament: tournament)

      notification = Notification.create(
        user:       subscription.tournament.user,
        content:    "#{subscription.user.full_name} a demandé à s'inscrire à #{subscription.tournament.name}",
        tournament: subscription.tournament
      )

      redirect_to new_subscription_disponibility_path(subscription)
    else
      flash[:alert] = 'Un problème est survenu lors du paiement. Merci de bien vouloir réessayer plus tard.'
      redirect_to tournament_path(tournament)
    end
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à procéder à votre inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_path(tournament)
  end
end
