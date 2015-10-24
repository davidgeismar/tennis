class AeiExportsController < ApplicationController
  before_action :set_competition

  def create
   authorize @competition
   aei = AEI.new(params[:login_aei], params[:password_aei])
   flashes = aei.create(@competition, params[:subscription_ids_export].split(","))
   flashes.each do |key, value|
      flash[key] = value
   end
   redirect_to competition_subscriptions_path(@competition)
   rescue AEI::ParamError
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
      redirect_to competition_subscriptions_path(@competition)
   rescue AEI::HomologationError
      flash[:alert] = "Le numéro d'homologation n'a pas été trouvé"
      return redirect_to competition_subscriptions_path(@competition)
   rescue AEI::LoginError
      flash[:alert] = "Il n'y a aucun compte avec ces informations."
      redirect_to competition_subscriptions_path(@competition)
  end

  def export_disponibilities
    authorize @competition

    if params[:subscription_ids_export_dispo].blank?
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
      redirect_to competition_subscriptions_path(competition.id)
    else
      aei = AEI.new(params[:login_aei], params[:password_aei])
      errors = aei.export_disponibilities(@competition, params[:subscription_ids_export_dispo].split(','))
      flash[:notice] = "les disponibilités de vos inscrits ont bien été exportés"
      redirect_to competition_subscriptions_path(@competition)
    end
    rescue AEI::LoginError
      flash[:alert] = "Il n'y a aucun compte avec ces informations."
      redirect_to competition_subscriptions_path(@competition)
  end


  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
    custom_authorize AEIExportPolicy, @competition
  end

end
