class SubscriptionsController < ApplicationController
  skip_after_action :verify_authorized, only: [:mytournaments]

  def mytournaments
    @tournaments = current_user.tournaments
    @passed_tournaments = []
    @tournaments.each do |tournament|
      if tournament.passed?
        @passed_tournaments << tournament
      end
    end

    @subscriptions = Subscription.where(user_id: current_user)

    if @subscriptions.blank? && current_user.judge == false
      flash[:notice] = "Vous ne vous êtes pas encore inscrit à un tournoi."
    end
    #writte custom policy
  end

  def index
    @rankings = ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']
    @user = current_user
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    authorize @subscriptions
    policy_scope(@subscriptions)
  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  def new
    @tournament   = Tournament.find(params[:tournament_id])
    @subscription = @tournament.subscriptions.build
    authorize @subscription

    unless tournament_available_for_user?
      return redirect_to tournament_path(@tournament)
    end

    unless current_user.mangopay_user_id
      MangoPayments::Users::CreateNaturalUserService.new(current_user).call
      MangoPayments::Users::CreateWalletService.new(current_user).call
    end

    @card         = MangoPayments::Users::CreateCardRegistrationService.new(current_user).call
    @subscription = @tournament.subscriptions.build
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à procéder à votre inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_path(@tournament)
  end

  def create
    current_user.update(mangopay_card_id: params[:card_id])

    tournament    = Tournament.find(params[:tournament_id])
    subscription  = Subscription.new(user: current_user, tournament: tournament)
    service       = MangoPayments::Subscriptions::CreatePayinService.new(subscription)
    authorize subscription

    if service.call
      SubscriptionMailer.confirmation(subscription).deliver

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

  def update
    @subscription = Subscription.find(params[:id])
    authorize @subscription

    if subscription_params[:status] == "canceled" ||
      (subscription_params[:status] == "refused" && @subscription.user.invitation_token.blank?)
      mangopay_refund
    end

    @subscription.update(subscription_params)

    if @subscription.status == "refused"
      @subscription.user.notifications.create(content: "Votre inscription à #{@subscription.tournament.name} a été refusée")
    elsif @subscription.status == "confirmed"
      @subscription.user.notifications.create(content: "Votre inscription à #{@subscription.tournament.name} a été confirmée")
    end

    unless @subscription.exported
      case @subscription.status
      when "confirmed"
        SubscriptionMailer.confirmed(@subscription).deliver
      when "refused"
        SubscriptionMailer.refused(@subscription).deliver
      when "confirmed_warning"
        SubscriptionMailer.confirmed_warning(@subscription).deliver
      end
    end

    redirect_to tournament_subscriptions_path(@subscription.tournament)
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à mettre à jour l'inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  # pas possible de créer un nouveau transfert ! il faudrait demander le numéro de carte du JA
  # et bien faire des mangopay_refund
  def accept # accept_player
    @subscription = Subscription.find(params[:id])
    authorize @subscription

    @subscription.status = "confirmed_warning"
    @subscription.save

    unless @subscription.exported
      SubscriptionMailer.confirmed_warning(@subscription).deliver
    end

    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def refund
    @subscription = Subscription.find(params[:id])
    authorize @subscription

    if mangopay_refund
      @subscription.status = "refused"
      @subscription.save

      unless @subscription.exported
        SubscriptionMailer.refused(@subscription).deliver
      end

      @notification = Notification.create(
        user:     @subscription.user,
        content:  "Nous avons le regret de vous apprendre que le juge arbitre de #{@subscription.tournament.name} a finalement annulé votre inscription."
      )

      #insérer mailer
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:notice] = "Vous avez bien procédé au remboursement de #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
    else
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:warning] = "Le remboursement n'a pas pu etre effectué. Merci de réessayer plus tard"
    end
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à mettre à jour l'inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def refuse # refus_without_remboursement
    @subscription = Subscription.find(params[:id])
    authorize @subscription

    @subscription.status = "refused"
    @subscription.save

    unless @subscription.exported
      SubscriptionMailer.refused(@subscription).deliver
    end

    flash[:notice] = "Vous avez bien désinscrit #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi."
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  private

  def age_when_tournament_starts
    tournament_starting_date = @subscription.tournament.starts_on
    tournament_starting_date.year - current_user.birthdate.year
  end

  def mangopay_refund
    MangoPayments::Subscriptions::CreateRefundService.new(@subscription).call
  end

  def set_subscription
    @subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:status, :disponibilities)
  end

  def tournament_available_for_user?
    if current_user.profile_complete? == false
      flash[:alert] = "Vous devez d'abord remplir <a href=#{user_path(current_user)}>votre profil</a> entièrement avant de pouvoir vous inscrire à ce tournoi"
      return false
    elsif current_user.subscriptions.where(tournament: @tournament).exists?
      flash[:alert] = "Vous êtes déjà inscrit à ce tournoi"
      return false
    elsif @tournament.open_for_ranking?(current_user.ranking) == false
      flash[:alert] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      return false
    elsif @tournament.open_for_genre?(current_user.genre) == false
      flash[:alert] = "Ce tournoi n'est pas mixte. Vous ne pouvez pas vous inscrire"
      return false
    elsif @tournament.open_for_birthdate?(current_user.birthdate) == false
      flash[:alert] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      return false
    end

    true
  end
end
