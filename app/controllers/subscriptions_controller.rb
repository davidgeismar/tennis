class SubscriptionsController < ApplicationController
  skip_after_action :verify_authorized, only: [:mytournaments]

  def mytournaments
    @subscriptions = Subscription.where(user_id: current_user)

    if @subscriptions.blank? && current_user.judge == false
      flash[:notice] = "Vous ne vous êtes pas encore inscrit à un tournoi."
    end
    #writte custom policy
  end

  def stop_subscription
    # recup data from ranking
    # return an array with all rankings
  end

  def index
    @rankings = ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']
    @user = current_user
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    authorize @subscriptions
    policy_scope(@subscriptions)
  end

  def refuse # refus_without_remboursement
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.status = "refused"
    @subscription.save

    flash[:notice] = "Vous avez bien désinscrit #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  # pas possible de créer un nouveau transfert ! il faudrait demander le numéro de carte du JA
  # et bien faire des mangopay_refund
  def accept # accept_player
    @subscription = Subscription.find(params[:id])
    @subscription.status = "confirmed_warning"
    authorize @subscription
    @subscription.save

    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def refund
    @subscription = Subscription.find(params[:id])
    if mangopay_refund
      @subscription.status = "refused"
      authorize @subscription
      @subscription.save
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Nous avons le regret de vous apprendre que le juge arbitre de #{@subscription.tournament.name} a finalement annulé votre inscription."
      #insérer mailer
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:notice] = "Vous avez bien procédé au remboursement de #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
    else
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:warning] = "Le remboursement n'a pas pu etre effectué. Merci de réessayer plus tard"
    end
  end

  def update
    #mangopay refund en cas de subscription.status = refused
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.update(subscription_params)

    if @subscription.status == "refused" && @subscription.user.invitation_token.blank?
      mangopay_refund
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Votre inscription à #{@subscription.tournament.name} a été refusé"
      @notification.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    elsif @subscription.status == "refused" && @subscription.user.invitation_token
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Votre inscription à #{@subscription.tournament.name} a été refusé"
      @notification.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    elsif @subscription.status == "canceled"
      mangopay_refund
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    else
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Votre inscription à #{@subscription.tournament.name} a été confirmé"
      @notification.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    end
  end

  def new #gérer tous les ages catégories d'inscription
    @tournament   = Tournament.find(params[:tournament_id])
    @subscription = @tounament.subscriptions.build
    authorize @subscription

    # le 30 septembre il faut faire year.now - age
    if @subscription.tournament.total == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "NC" && @subscription.tournament.NC == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "40" && @subscription.tournament.quarante == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30/5" && @subscription.tournament.trentecinq == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30/4" && @subscription.tournament.trentequatre == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30/3" && @subscription.tournament.trentetrois == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30/2" && @subscription.tournament.trentedeux == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30/1" && @subscription.tournament.trenteun == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "30" && @subscription.tournament.trente == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15/5" && @subscription.tournament.quinzecinq == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15/4" && @subscription.tournament.quinzequatre == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15/3" && @subscription.tournament.quinzetrois == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15/2" && @subscription.tournament.quinzedeux == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15/1" && @subscription.tournament.quinzeun == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "15" && @subscription.tournament.quinze == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "5/6" && @subscription.tournament.cinqsix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "4/6" && @subscription.tournament.quatresix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "3/6" && @subscription.tournament.troissix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "2/6" && @subscription.tournament.deuxsix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "1/6" && @subscription.tournament.unsix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "0" && @subscription.tournament.zero == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "-2/6" && @subscription.tournament.moinsdeuxsix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "-4/6" && @subscription.tournament.moinsquatresix == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "-15" && @subscription.tournament.moinsquize == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    elsif current_user.ranking == "-30" && @subscription.tournament.moinstrente == false
      flash[:notice] = "Ce tournoi n'accepte plus d'inscrits à votre classement"
      redirect_to tournament_path(@tournament)
    end
  end

  def create
    @tournament   = Tournament.find(params[:tournament_id])
    @subscription = @tournament.subscriptions.build
    authorize @subscription

    arrayminor = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']
    arrayinf18 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans']
    arrayinf16 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans']
    arrayinf14 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans']
    arrayinf12 = ['9 ans', '9-10ans', '10 ans', '11 ans']
    arrayinf11 = ['9 ans', '9-10ans', '10 ans']
    ranking_array = ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']

    user_ranking_index = ranking_array.index(current_user.ranking)
    tournament_max_ranking_index = ranking_array.index(@tournament.max_ranking)
    tournament_min_ranking_index = ranking_array.index(@tournament.min_ranking)

    if !current_user.profile_complete?
      flash[:alert] = "Vous devez d'abord remplir" + "<a href=#{user_path(current_user)}>" + "votre profil" + "</a>" + "entièrement avant de pouvoir vous inscrire à ce tournoi"
      redirect_to tournament_path(@tournament)

    # elsif user_ranking_index < tournament_min_ranking_index
    #   flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
    #   redirect_to tournament_path(@tournament)

    # elsif user_ranking_index > tournament_max_ranking_index
    #   flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
    #   redirect_to tournament_path(@tournament)

    elsif current_user.subscriptions.where(tournament: @tournament) != []
      flash[:alert] = "Vous êtes déjà inscrit à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif current_user.genre != @tournament.genre
      flash[:alert] = "Ce tournoi n'est pas mixte. Vous ne pouvez pas vous inscrire."
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "11 ans" && current_user.birthdate.year < 2004
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "12 ans" && current_user.birthdate.year < 2003
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "13 ans" && current_user.birthdate.year < 2002
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "14 ans" && current_user.birthdate.year < 2001
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "13-14 ans" && current_user.birthdate.year < 2001
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "15 ans" && current_user.birthdate.year < 2000
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "16 ans" && current_user.birthdate.year < 1999
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "15-16 ans" && current_user.birthdate.year < 1999
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "17 ans" && current_user.birthdate.year < 1998
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "18 ans" && current_user.birthdate.year < 1997
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "17-18 ans" && current_user.birthdate.year < 1997
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "35 ans" && current_user.birthdate.year > 1980
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "40 ans" && current_user.birthdate.year > 1975
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "45 ans" && current_user.birthdate.year > 1970
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "50 ans" && current_user.birthdate.year > 1965
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "55 ans" && current_user.birthdate.year > 1960
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "60 ans" && current_user.birthdate.year > 1955
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "65 ans" && current_user.birthdate.year > 1950
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "70 ans" && current_user.birthdate.year > 1945
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif @tournament.category == "75 ans" && current_user.birthdate.year > 1940
      flash[:notice] = "Vous n'avez pas l'age requis pour participer à ce tournoi"
      redirect_to tournament_path(@tournament)

    else
      unless current_user.mangopay_user_id && current_user.mangopay_wallet_id
        MangoPayments::Users::CreateNaturalUserService.new(current_user).call
        MangoPayments::Users::CreateWalletService.new(current_user).call
      end

      @card = MangoPayments::Users::CreateCardRegistrationService.new(current_user).call

      render :new
    end
  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  private

  def age_when_tournament_starts
    tournament_starting_date = @subscription.tournament.starts_on
    tournament_starting_date.year - current_user.birthdate.year
  end

  def mangopay_refund
    @transfer = @subscription.tournament.transfers.where("archive ->> 'AuthorId' = ?", "#{@subscription.user.mangopay_user_id}").first()
    MangoPay::PayIn.refund(@transfer.mangopay_transaction_id,{
        "AuthorId" => @subscription.user.mangopay_user_id,
      })
  end

  def set_subscription
    @subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:status, :disponibilities)
  end
end
