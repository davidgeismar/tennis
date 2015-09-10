class CompetitionsController < ApplicationController
  before_action :find_tournament
  before_action :set_competition, only: [:show, :edit, :update, :update_rankings]

  def new
    @competition = Competition.new
    authorize @competition
  end

  def create
    @competition =  Competition.new(competition_params)
    @competition.tournament = @tournament
    authorize @competition

    if @competition.save
      flash[:notice] = "Félicitation votre épreuve a bien été créée"
      redirect_to tournament_path(@tournament)
    else
      render :new
    end
  end

  def index
    @competitions = Competition.where(tournament_id: @tournament)
    policy_scope(@competitions)
  end

  def show
    authorize(@competition)
  end

  def edit
    @tournament = @competition.tournament
    authorize(@competition)
  end

  def update
    authorize @competition

    if @competition.update(competition_params)
      flash[:notice] = "Votre épreuve a bien été modifiée"
      redirect_to competition_subscriptions_path(@competition)
    else
      render :edit
    end
  end

  def update_rankings
    authorize @competition
    @competition.update(competition_params)
    render nothing: true
  end

  private

  def competition_params
    params.require(:competition).permit(
      :max_ranking,
      :min_ranking,
      :genre,
      :category,
      :nature,
      :total,
      :NC,
      :quarante,
      :trentecinq,
      :trentequatre,
      :trentetrois,
      :trentedeux,
      :trenteun,
      :trente,
      :quinzecinq,
      :quinzequatre,
      :quinzetrois,
      :quinzedeux,
      :quinzeun,
      :quinze,
      :cinqsix,
      :quatresix,
      :troissix,
      :deuxsix,
      :unsix,
      :zero,
      :moinsdeuxsix,
      :moinsquatresix,
      :moinsquinze,
      :premiereserie
      )
  end

  def find_tournament
    if params[:tournament_id] != nil
      @tournament = Tournament.find(params[:tournament_id])
    end
  end

  def set_competition
    if params[:id]
      @competition = Competition.find(params[:id])
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    end
  end
end