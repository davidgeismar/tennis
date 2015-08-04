 class TournamentsController < ApplicationController
  before_action :set_tournament,  only: [:update, :edit, :show]
  before_action :check_profile,   only: [:new, :create]

  def index

    @tournaments = policy_scope(Tournament)
    if @tournaments.blank? && current_user.judge?
      render 'pages/partials/_no_tournaments_judge'
    elsif @tournaments.blank?
      render 'pages/partials/_no_tournaments'
    end
  end

  def show
    if Time.now.utc.to_date > @tournament.ends_on
      flash[:alert] = "Le tournoi que vous cherchez est terminé."
      redirect_to root_path
    end
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
