class TournamentsController < ApplicationController
  skip_after_action :verify_authorized, only: [:invite_player, :invite_player_to_tournament, :registrate_card, :success_payment]
  def index
    @tournaments = policy_scope(Tournament)
  end

  def show
    @tournament = Tournament.find(params[:id])
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
    @tournament = Tournament.new(tournament_params)
    authorize @tournament
    @tournament.user = current_user
    @tournament.save
    redirect_to tournament_path(@tournament)
  end

  def edit
    @tournament = Tournament.find(params[:id])
    authorize @tournament
  end

  def update
    @tournament = Tournament.find(params[:id])
    authorize @tournament
    @tournament.update(tournament_params)
  end

  def invite_player
    @tournament = Tournament.find(params[:id])
  end

  def invite_player_to_tournament
    @tournament = Tournament.find(params[:id])
    User.invite!(:email => params[:email], :name => params[:first_name] + " " + params[:last_name])
    @user = User.find_by(email: params[:email])
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.save
    @subscription = Subscription.new(user: @user, tournament: @tournament)
    if @subscription.save
      redirect_to tournament_subscriptions_path(@tournament)
    else
      render :invite_player
    end
  end

  def success_payment
    @tournament = Tournament.find(params[:tournament_id])
  end
  def registrate_card
    tournament = Tournament.find(params[:tournament_id])
    if current_user.first_name == "" || current_user.last_name == "" || current_user.licence_number == "" || current_user.telephone == ""
      flash[:alert] = "Vous devez remplir votre profil pour pouvoir vous inscrire à ce tournoi"
      redirect_to tournament_path(tournament)

    # elsif current_user.subscriptions(tournament_id: tournament.id)
    #   flash[:alert] = "Vous etes déjà inscrit à ce tournoi"
    #   redirect_to tournament_path(tournament)
    else
      card = MangoPay::CardRegistration.create({UserId: current_user.mangopay_natural_user_id, Currency:"EUR"})

      redirect_to new_tournament_subscription_path(
        access_key: card["AccessKey"],
        preregistration_data: card["PreregistrationData"],
        card_registration_url: card["CardRegistrationURL"],
        card_registration_id: card["Id"],
        tournament_id: params[:tournament_id])
    end
  end

  def find
    @tournament = Tournament.new
    authorize @tournament
  end

  private

  def tournament_params
    params.require(:tournament).permit(:genre, :category, :amount, :starts_on, :ends_on, :address, :club_organisateur, :name, :city, :lat, :long)
  end
end
