class DisponibilitiesController < ApplicationController
  before_action :set_tournament
  before_action :set_disponibility, only: [:edit, :update, :show]

  def new
    @disponibility            = Disponibility.new
    @disponibility.user       = current_user
    @disponibility.tournament = @tournament
    authorize @disponibility
    if current_user.profile_complete? == false
      flash[:alert] = "Vous devez d'abord remplir <a href=#{edit_user_path(current_user)}>votre profil</a> entièrement avant de pouvoir vous inscrire à ce tournoi."
      redirect_to edit_user_path(current_user)
    end
  end

  def create
    @disponibility            = Disponibility.new
    @disponibility.tournament = @tournament
    if current_user.judge?
      if params[:method] == "JSON"
        if !params[:dispo_array].blank?
          authorize @disponibility
          disponibilities           = JSON.parse(params[:dispo_array])
          @disponibility.user       = current_user
          authorize @disponibility
          @disponibility.monday     =
          @disponibility.tuesday    = disponibilities_for_day(disponibilities, 'mardi')
          @disponibility.wednesday  = disponibilities_for_day(disponibilities, 'mercredi')
          @disponibility.thursday   = disponibilities_for_day(disponibilities, 'jeudi')
          @disponibility.friday     = disponibilities_for_day(disponibilities, 'vendredi')
          @disponibility.saturday   = disponibilities_for_day(disponibilities, 'samedi')
          @disponibility.sunday     = disponibilities_for_day(disponibilities, 'dimanche')
          @subscription             = Subscription.find(params[:subscription_id])
          @disponibility.user       = @subscription.user
        else
          authorize @disponibility
          flash[:alert] = "Merci d'indiquer au minimum une disponibilité"
          redirect_to new_tournament_disponibility_path(@tournament) and return
        end
      else
        @disponibility.user       = current_user
        authorize @disponibility
        @disponibility.assign_attributes(disponibility_params)
        @subscription             = Subscription.find(params[:subscription_id])
        @disponibility.user      = @subscription.user
      end

    else
      if params[:method] == "JSON"
        if !params[:dispo_array].blank?
          disponibilities           = JSON.parse(params[:dispo_array])
          @disponibility.user       = current_user
          authorize @disponibility
          @disponibility.monday     = disponibilities_for_day(disponibilities, 'lundi')
          @disponibility.tuesday    = disponibilities_for_day(disponibilities, 'mardi')
          @disponibility.wednesday  = disponibilities_for_day(disponibilities, 'mercredi')
          @disponibility.thursday   = disponibilities_for_day(disponibilities, 'jeudi')
          @disponibility.friday     = disponibilities_for_day(disponibilities, 'vendredi')
          @disponibility.saturday   = disponibilities_for_day(disponibilities, 'samedi')
          @disponibility.sunday     = disponibilities_for_day(disponibilities, 'dimanche')
        else
          @disponibility.user       = current_user
          authorize @disponibility
          flash[:alert] = "Merci d'indiquer au minimum une disponibilité"
          redirect_to new_tournament_disponibility_path(@tournament) and return
        end
      else
        @disponibility.user       = current_user
        authorize @disponibility
        @disponibility.assign_attributes(disponibility_params) #update sans faire de bdd
      end
    end

    if @disponibility.save
      if current_user.judge?
        redirect_to competition_subscriptions_path(@subscription.competition)
        flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
      else
        redirect_to tournament_competitions_path(@tournament)
        flash[:notice] = "Vos disponibilités ont bien été enregistrées"
      end
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
    @subscription = Subscription.find(params[:subscription_id])

    if @disponibility.update(disponibility_params)
      redirect_to competition_subscriptions_path(@subscription.competition)
      flash[:notice] = "Les disponibilités du licencié ont bien été enregistrées"
    else
      render "edit"
    end
  end

  private

  def disponibilities_for_day(disponibilities, day)
    day_disponibilities = disponibilities.select { |hash| hash['day'] == day }
    day_disponibilities.map { |hash| "#{hash['start_time']}-#{hash['end_time']}" }.join(', ')
  end

  def disponibility_params
    params.require(:disponibility).permit(
      :week,
      :saturday,
      :sunday,
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :comment,
      :subscription_id
    )
  end

  def set_disponibility
    @disponibility = Disponibility.find(params[:id])
  end

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
