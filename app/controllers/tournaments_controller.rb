class TournamentsController < ApplicationController
  def index
    @tournaments = policy_scope(Tournament)
  end

  def show
    @tournament = Tournament.find(params[:id])
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


  private

  def tournament_params
    params.require(:tournament).permit(:genre, :category, :amount, :starts_on, :ends_on, :address, :club_organisateur, :name, :city)
  end
end
