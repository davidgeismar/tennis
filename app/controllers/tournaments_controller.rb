 class TournamentsController < ApplicationController
  before_action :set_tournament,  only: [:update, :edit, :show]
  before_action :check_profile,   only: [:new, :create]

  def index
    @tournaments = policy_scope(Tournament)
    if @tournaments.blank?
     render 'pages/partials/_no_tournaments'
    end
  end

  def show
    @markers = Gmaps4rails.build_markers(@tournament) do |tournament, marker|
      marker.lat tournament.latitude
      marker.lng tournament.longitude
    end
    authorize @tournament
  end

  def new
    @tournament = Tournament.new
    authorize @tournament
  end

  def create
    @tournament                     = Tournament.new(tournament_params)
    @tournament.user                = current_user
    @tournament.homologation_number = params[:tournament][:homologation_number].split.join
    authorize @tournament

    service = MangoPayments::Tournaments::SetupService.new(@tournament)

    if @tournament.save && service.call
      redirect_to tournament_path(@tournament)
    else
      render 'new'
    end
  rescue MangoPay::ResponseError => e
    flash[:alert] = "L'IBAN ou le BIC que vous avez fourni n'est pas valide. Veuillez vérifier les informations fournies. Si le problème persiste n'hésitez pas à contacter l'équipe WeTennis."
    redirect_to new_tournament_path
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament
    @tournament.update(tournament_params)
    @tournament.accepted = false
    @tournament.save
  end

  def update_rankings
    @tournament = Tournament.find(params[:tournament_id])
    authorize @tournament
    @tournament.update(tournament_params)
    @tournament.save
    render nothing: true
  end

  def registrate_card #creating mangopay user and wallet for payer #checking category here
    authorize @tournament
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
      unless current_user.mangopay_user_id
        MangoPayments::Users::CreateNaturalUserService.new(current_user).call
        MangoPayments::Users::CreateWalletService.new(current_user).call
      end

      @card         = MangoPayments::Users::CreateCardRegistrationService.new(current_user).call
      @subscription = @tournament.subscriptions.build

      render 'subscriptions/new'
    end
  end

  private

  def check_profile
    if !current_user.profile_complete?
      flash[:alert] = "Vous devez d'abord remplir" + "<a href=#{user_path(current_user)} class='profil_link'>" + "votre profil" + "</a>"  + "entièrement pour pouvoir ajouter votre tournoi"
      redirect_to root_path
    elsif !current_user.accepted
      flash[:alert] = "Votre compte Juge Arbitre doit d'abord avoir été accepté par l'équipe WeTennis avant de pouvoir ajouter un tournoi. Assurez vous d'avoir bien rempli intégralement" + "<a href=#{user_path(current_user)} class='profil_link'>" + "votre profil" + "</a>" + "afin d'avoir une réponse rapide."
      redirect_to root_path
    end
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(
      :address,
      :amount,
      :bic,
      :category,
      :cinqsix,
      :city,
      :club_email,
      :club_organisateur,
      :deuxsix,
      :ends_on,
      :genre,
      :homologation_number,
      :iban,
      :lat,
      :long,
      :max_ranking,
      :min_ranking,
      :moinsdeuxsix,
      :moinsquatresix,
      :moinsquinze,
      :moinstrente,
      :name,
      :nature,
      :NC,
      :postcode,
      :quarante,
      :quatresix,
      :quinze,
      :quinzecinq,
      :quinzedeux,
      :quinzequatre,
      :quinzetrois,
      :quinzeun,
      :starts_on,
      :total,
      :trente,
      :trentecinq,
      :trentedeux,
      :trentequatre,
      :trentetrois,
      :trenteun,
      :troissix,
      :unsix,
      :young_fare,
      :zero
    )
  end
end
