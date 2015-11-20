class SubscriptionsController < ApplicationController
  skip_after_action :verify_authorized, only: [:mytournaments]

  def index
    @rankings       = ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']
    @user           = current_user
    @competition    = Competition.find(params[:competition_id])
    @tournament     = @competition.tournament
    @subscriptions  = @competition.subscriptions

    custom_authorize SubscriptionMultiPolicy, @subscriptions
    policy_scope(@subscriptions)
  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  def multiple_new
    @competition_ids  = params[:select_competitions].split(',') # ["27", "38", "37", "35"]
    @tournament       = Tournament.find(params[:tournament_id])

    if @competition_ids.blank?
      flash[:alert] = "Vous n'avez sélectionné aucune catégories"
      redirect_to tournament_competitions_path(@tournament)
    end

    @competitions = Competition.where(id: @competition_ids) # array of competitions
    number        = @competition_ids.length
    custom_authorize CompetitionMultiPolicy, @competitions

    if current_user.eligible_for_young_fare?
      @total_amount = (@tournament.young_fare*number).to_f
    else
      @total_amount = (@tournament.amount*number).to_f
    end

    fees_amount   = (Settings.tournament.fees_cents / 100.0)
    @total_amount = @total_amount + fees_amount

    # authorize @subscription
    @competitions.each do |competition|
      unless competition_available_for_user?(competition)
        return redirect_to tournament_competitions_path(@tournament)
      end
    end

    unless current_user.mangopay_user_id
      MangoPayments::Users::CreateNaturalUserService.new(current_user).call
      MangoPayments::Users::CreateWalletService.new(current_user).call
    end

    @card = MangoPayments::Users::CreateCardRegistrationService.new(current_user).call
    # @subscription = @competition.subscriptions.build
  rescue MangoPay::ResponseError => e
    Appsignal.add_exception(e)
    flash[:alert] = "Nous ne parvenons pas à procéder à votre inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_path(@tournament)
  end

  def multiple_create
    current_user.update(mangopay_card_id: params[:card_id])

    # les épreuves auxquelles le joueeur veut s'inscrire
    @competition_ids  = params[:competition_ids].split
    @competitions     = Competition.where(id: @competition_ids)


    fare_type         = current_user.eligible_for_young_fare? ? :young : :standard
    tournament        = Tournament.find(params[:tournament_id])

    custom_authorize CompetitionMultiPolicy, @competition
    subscriptions = []
    # pour chaque épreuve je crée une subscription
    @competitions.each do |competition|
      subscription  = Subscription.new(user: current_user, competition: competition, fare_type: fare_type, tournament_id: tournament.id)
      subscriptions << subscription
    end

    # j'appelle le mangopaypayin service
    service       = MangoPayments::Subscriptions::CreatePayinService.new(subscriptions, tournament, current_user)

    if subscriptions = service.call
       SubscriptionEmailsWorker.perform_async(subscriptions.map(&:id))
      # SubscriptionMailer.confirmation(subscriptions).deliver
      # SubscriptionMailer.confirmation_judge(subscriptions).deliver
      # SubscriptionMailer.new_subscription(subscription).deliver
      # subscriptions.each do |subscription|
      #   notification = Notification.create(
      #     user:       subscription.tournament.user,
      #     content:    "#{subscription.user.full_name} a demandé à s'inscrire à #{subscription.tournament.name} dans la catégorie #{subscription.competition.category} ",
      #     competition_id: subscription.competition.id
      #   )
      # end
    else
      flash[:alert] = 'Un problème est survenu lors du paiement. Merci de bien vouloir réessayer plus tard.'
      return redirect_to tournament_path(tournament)
    end


    if current_user.profile_ultra_complete?
      flash[:notice] = "Votre demande d'inscription a bien été prise en compte. Vous recevrez une réponse du Juge arbitre dans les plus brefs délais"
    else
      flash[:notice] = "Votre demande d'inscription a bien été envoyée. Pour recevoir une réponse rapide du juge-arbitre, merci de bien vouloir uploader votre licence et votre certificat médical (prenez les en photos !)"
    end
    return redirect_to mytournaments_path


  rescue MangoPay::ResponseError => e
     Appsignal.add_exception(e)
    flash[:alert] = "Nous ne parvenons pas à procéder à votre inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
  end

  def new
    @competition    = Competition.find(params[:competition_id])
    @tournament     = @competition.tournament
    @subscription   = @competition.subscriptions.build(competition: @competition)

    if current_user.eligible_for_young_fare?
      @total_amount = @tournament.young_fare.to_f
    else
      @total_amount = @tournament.amount.to_f
    end

    fees_amount     = (Settings.tournament.fees_cents / 100.0)
    @total_amount  += (@total_amount + fees_amount)

    authorize @subscription

    unless competition_available_for_user?
      return redirect_to tournament_competitions_path(@tournament)
    end

    unless current_user.mangopay_user_id
      MangoPayments::Users::CreateNaturalUserService.new(current_user).call
      MangoPayments::Users::CreateWalletService.new(current_user).call
    end

    @card         = MangoPayments::Users::CreateCardRegistrationService.new(current_user).call
    @subscription = @competition.subscriptions.build
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à procéder à votre inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to tournament_path(@tournament)
  end

  def create
    current_user.update(mangopay_card_id: params[:card_id])

    competition   = Competition.find(params[:competition_id])
    fare_type     = current_user.eligible_for_young_fare? ? :young : :standard
    tournament    = competition.tournament
    subscription  = Subscription.new(user: current_user, competition: competition, fare_type: fare_type)
    service       = MangoPayments::Subscriptions::CreatePayinService.new(subscription)

    authorize subscription

    if service.call
      SubscriptionMailer.confirmation(subscription).deliver

      notification = Notification.create(
        user:       subscription.tournament.user,
        content:    "#{subscription.user.full_name} a demandé à s'inscrire à #{subscription.tournament.name} dans la catégorie #{subscription.competition.category} ",
        competition_id: subscription.competition.id
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
      @subscription.user.notifications.create(content: "Votre inscription à #{@subscription.tournament.name} dans la catégorie #{@subscription.competition.category} a été refusée")
    elsif @subscription.status == "confirmed"
      @subscription.user.notifications.create(content: "Votre inscription à #{@subscription.tournament.name} dans la catégorie #{@subscription.competition.category} a été confirmée")
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

    redirect_to competition_subscriptions_path(@subscription.competition)
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à mettre à jour l'inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to competition_subscriptions_path(@subscription.competition)
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

    redirect_to competition_subscriptions_path(@subscription.competition)
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
        content:  "Nous avons le regret de vous apprendre que le juge arbitre de #{@subscription.tournament.name} a finalement annulé votre inscription dans la catégorie #{@subscription.competition.category}."
      )

      #insérer mailer
      redirect_to competition_subscriptions_path(@subscription.competition)
      flash[:notice] = "Vous avez bien procédé au remboursement de #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
    else
      redirect_to competition_subscriptions_path(@subscription.competition)
      flash[:warning] = "Le remboursement n'a pas pu etre effectué. Merci de réessayer plus tard"
    end
  rescue MangoPay::ResponseError => e
    flash[:alert] = "Nous ne parvenons pas à mettre à jour l'inscription. Veuillez renouveler votre demande. Si le problème persiste, veuillez contacter le service client [#{e.code}]."
    redirect_to competition_subscriptions_path(@subscription.competition)
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
    redirect_to competition_subscriptions_path(@subscription.competition)
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

  def competition_available_for_user?(competition)
    if current_user.profile_complete? == false
      flash[:alert] = "Vous devez d'abord remplir <a href=#{edit_user_path(current_user)}>votre profil</a> entièrement avant de pouvoir vous inscrire à ce tournoi."
      return false
    elsif current_user.subscriptions.where(competition: competition).exists?
      flash[:alert] = "Vous êtes déjà inscrit à ce tournoi dans cette catégorie"
      return false
    elsif competition.open_for_ranking?(current_user.ranking) == false
      flash[:alert] = "Cette épreuve n'accepte plus d'inscrits à votre classement"
      return false
    elsif competition.in_ranking_range?(current_user.ranking) == false
      flash[:alert] = "Vous n'avez pas le classement requis pour participer à cette épreuve"
      return false
    elsif competition.open_for_genre?(current_user.genre) == false
      flash[:alert] = "Cette épreuve n'est pas mixte. Vous ne pouvez pas vous inscrire"
      return false
    elsif competition.open_for_birthdate?(current_user.birthdate) == false
      flash[:alert] = "Vous n'avez pas l'age requis pour participer à l'une des épreuves que vous avez sélectionné"
      return false
    end
    true
  end
end
