 class TournamentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_tournament,  only: [:update, :edit, :show, :destroy]
  before_action :check_profile,   only: [:create]

  def index
    @tournaments = policy_scope(Tournament)
    if current_user.nil? && params[:content].blank?
    elsif @tournaments.blank? && current_user.judge?
      render 'pages/partials/_no_tournaments_judge'
    elsif @tournaments.blank?
      render 'pages/partials/_no_tournaments'
    elsif params[:content].present?
      @tournaments = Tournament.near(params[:content], 20, units: :km).where(accepted: true).where("ends_on >= :today", today: Date.today)

      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def destroy
    authorize @tournament
    if @tournament.subscriptions.blank?
      @tournament.destroy
      redirect_to mytournaments_path
    else
      flash[:alert] = "Il y a déjà des inscriptions au tournoi. Contactez l'équipe WeTennis si vous souhaitez supprimer ce tournoi"
      redirect_to mytournaments_path
    end
  end

  def show
    if Time.now.utc.to_date > @tournament.ends_on
      flash[:alert] = "Le tournoi que vous cherchez est terminé."
      redirect_to root_path
    elsif @tournament.competitions.blank? && current_user.nil?
      flash[:alert] = "Il n'est pas encore possible de s'inscrire à ce tournoi. Merci de réessayer plus tard"
      redirect_to tournaments_path
    elsif current_user.nil?
    elsif @tournament.competitions.blank? && !current_user.judge?
      flash[:alert] = "Il n'est pas encore possible de s'inscrire à ce tournoi. Merci de réessayer plus tard"
      redirect_to tournaments_path
    end

    @markers = Gmaps4rails.build_markers(@tournament) do |tournament, marker|
      marker.lat tournament.latitude
      marker.lng tournament.longitude
    end

    authorize @tournament
  end

  def new
    @tournament = Tournament.new
    # binding.pry
    authorize @tournament
    check_profile

  end

  def create
    @tournament                     = Tournament.new(tournament_params)
    @tournament.user                = current_user
    @tournament.homologation_number = params[:tournament][:homologation_number].split.join
    @tournament.postcode            = params[:tournament][:postcode].split.join
    @tournament.iban                = params[:tournament][:iban].delete(' ')
    @tournament.bic                 = params[:tournament][:bic].delete(' ')
    authorize @tournament
    service = MangoPayments::Tournaments::SetupService.new(@tournament)
    if @tournament.save && service.call
      TournamentMailer.created(@tournament).deliver
      redirect_to tournament_path(@tournament)
    else
      render :new
    end
  rescue MangoPay::ResponseError => e
    Appsignal.add_exception(e)
    @tournament.destroy
    flash.now[:alert] = "#{e.message} CODE: [#{e.code}]"
    render :new
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament
    @tournament.homologation_number = params[:tournament][:homologation_number].split.join
    @tournament.update(tournament_params)
    @tournament.accepted = false

    if @tournament.save
      TournamentMailer.edited(@tournament).deliver
      redirect_to tournament_path(@tournament)
    else
      render :edit
    end
  end

  private

  def check_profile
    if !current_user.profile_complete?
      flash[:alert] = "Vous devez d'abord remplir" + "<a href=#{edit_user_path(current_user)} class='profil_link'>" + " votre profil " + "</a>"  + "pour pouvoir ajouter votre tournoi"
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
      :cinqsix,
      :city,
      :club_email,
      :club_organisateur,
      :ends_on,
      :genre,
      :homologation_number,
      :iban,
      :lat,
      :long,
      :name,
      :NC,
      :postcode,
      :starts_on,
      :young_fare,
      :club_fare,
      :region,
      :fft
    )
  end
end
