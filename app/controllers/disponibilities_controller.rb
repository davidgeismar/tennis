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
    array_dispo = params[:dispo_array]
    array_dispo_json = JSON.parse(array_dispo)
    monday = array_dispo_json.select {|hash| hash["day"] == "lundi" }
    monday_disponibilities = ""
    monday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      monday_disponibilities += slot_dispo
    end
    tuesday = array_dispo_json.select {|hash| hash["day"] == "mardi" }
    tuesday_disponibilities = ""
    tuesday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      tuesday_disponibilities += slot_dispo
    end

    wednesday = array_dispo_json.select {|hash| hash["day"] == "mercredi" }
    wednesday_disponibilities = ""
    wednesday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      wednesday_disponibilities += slot_dispo
    end

    thursday = array_dispo_json.select {|hash| hash["day"] == "jeudi" }
    thursday_disponibilities = ""
    thursday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      thursday_disponibilities += slot_dispo
    end

    friday = array_dispo_json.select {|hash| hash["day"] == "vendredi" }
    friday_disponibilities = ""
    friday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      friday_disponibilities += slot_dispo
    end
    saturday = array_dispo_json.select {|hash| hash["day"] == "samedi" }
    saturday_disponibilities = ""
    saturday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      saturday_disponibilities += slot_dispo
    end

    sunday = array_dispo_json.select {|hash| hash["day"] == "dimanche" }
    sunday_disponibilities = ""
    sunday.each do |hash|
      slot_dispo = hash["start_time"] + "-" + hash["end_time"] + ", "
      sunday_disponibilities += slot_dispo
    end
    @disponibility = Disponibility.new
    @disponibility.tournament = @tournament
    if !current_user.judge?
      @disponibility.user = current_user
      @disponibility.monday = monday_disponibilities
      @disponibility.tuesday = tuesday_disponibilities
      @disponibility.wednesday = wednesday_disponibilities
      @disponibility.thursday = thursday_disponibilities
      @disponibility.friday = friday_disponibilities
      @disponibility.saturday = saturday_disponibilities
      @disponibility.sunday = sunday_disponibilities
      authorize @disponibility
    else
      @subscription = Subscription.find(params[:disponibility][:subscription_id])
      @disponibility.user = @subscription.user
      authorize @disponibility
    end
    if @disponibility.save && current_user.judge?
      redirect_to competition_subscriptions_path(@subscription.competition)
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
   @subscription = Subscription.find(params[:disponibility][:subscription_id])
   if @disponibility.update(disponibility_params)
    redirect_to competition_subscriptions_path(@subscription.competition)
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
    params.require(:disponibility).permit(:week, :saturday, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :comment, :subscription_id)
  end

end
