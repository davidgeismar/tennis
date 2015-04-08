class ConvocationsController < ApplicationController
  before_action :find_subscription, except: [:multiple_new, :multiple_create]
  skip_after_action :verify_authorized, only: [:multiple_new, :multiple_create]

  def new
    @convocation = @subscription.convocations.build
    authorize @convocation
  end

  def create
    @convocation = @subscription.convocations.build(convocation_params)
    authorize @convocation
    @convocation.save


    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def edit
    authorize @convocation
  end

  def update
    authorize @convocation
    @convocation.update(convocation_params)
    redirect_to new_convocation_message_path(@convocation)
  end

  def multiple_new
    @tournament = Tournament.find(params[:tournament_id])
    @subscription_ids_string = params[:subscription_ids]
    if @subscription_ids_string == ''
      flash[:alert] = "Vous n'avez sélectionné aucun joueur"
      redirect_to tournament_subscriptions_path(@tournament)
    # @tournament = Tournament.find(params[:tournament_id])
    # @subscription_ids_string = params[:subscription_ids]
    else
      @subscription_ids = params[:subscription_ids].split(', ')
      @player_names = []
      @subscription_ids.each do |subscription_id|
        @player_names << Subscription.find(subscription_id).user.name
      end
    end

  end

  def multiple_create
    @tournament = Tournament.find(params[:tournament_id])
    @subscription_ids = params[:subscription_ids].split(', ')
    @subscription_ids.each do |subscription_id|
      @subscription = Subscription.find(subscription_id)
      convocation = Convocation.create(date: params[:date], hour: params[:hour], subscription: @subscription)
      if convocation.save
        flash[:alert] = "Votre convocation a bien été envoyé"


        client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

      # Create and send an SMS message
        client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: convocation.subscription.user.telephone,
        body: "Vous etes convoque  #{convocation.date.strftime("le %d/%m/%Y")} #{convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{convocation.subscription.tournament.name} "
      )
      else
        flash[:warning] = "Un problème est survenu veuillez réessayer d'envoyer votre convocation"
      end
    end
    redirect_to tournament_subscriptions_path(@tournament)
  end


  # def update
  #   @subscription = Subscription.find(params[:id])
  #   authorize @subscription
  #   @subscription.update(subscription_params)
  #   redirect_to tournament_subscriptions_path(@subscription.tournament)
  # end

  private

  def convocation_params
    if current_user.judge?
      params.require(:convocation).permit(:hour, :date)
    else
      params.require(:convocation).permit(:status)
    end
  end

  def find_subscription
    if params[:subscription_id] != nil
      @subscription = Subscription.find(params[:subscription_id])
    else
      @convocation = Convocation.find(params[:id])
    end

  end
end


