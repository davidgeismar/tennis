class DisponibilitiesController < ApplicationController
  before_action :set_tournament
  before_action :set_disponibility, only: [:edit, :update, :show]

  def new
    @disponibility = Disponibility.new
    @disponibility.user = current_user
    @disponibility.tournament = @tournament
    authorize @disponibility
  end

  def create
    @disponibility = Disponibility.new(disponibility_params)
    @disponibility.tournament = @tournament
    @disponibility.user = current_user
    authorize @disponibility

    if @disponibility.save && current_user.judge?
      redirect_to mytournaments_path
      flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
    elsif  @disponibility.save
      redirect_to tournament_competitions_path(@tournament)
      flash[:notice] = "Vos disponibilités ont bien été enregistrées"
    else
      render 'new'
    end
  end

  def show
    authorize @disponibility
  end

  def edit
    authorize @disponibility
  end

  def update
   authorize @disponibility
   if @disponibility.update(disponibility_params)
    redirect_to mytournaments_path
    flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
   else
    render "edit"
   end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def set_disponibility
    @disponibility = Disponibility.find(params[:id])
  end

  def disponibility_params
    params.require(:disponibility).permit(:week, :saturday, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :comment)
  end

end
