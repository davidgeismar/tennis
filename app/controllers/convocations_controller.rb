  class ConvocationsController < ApplicationController
  before_action :find_subscription, except: [:multiple_new, :multiple_create]

  def new
    @convocation = @subscription.convocations.build
    authorize @convocation
  end

  def create
    @convocation = @subscription.convocations.build(convocation_params)
    authorize @convocation
    @convocation.save
    @notification = Notification.new
    @notification.user = @subscription.user
    @notification.content = "Vous êtes convoqué à #{@convocation.subscription.tournament.name} le #{@convocation.date.strftime("le %d/%m/%Y")} à #{@convocation.hour.strftime(" à %Hh%M")}"
    @notification.save
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def edit
    authorize @convocation
  end

  def update
    authorize @convocation
    @convocation.update(convocation_params)
    if @convocation.status == "refused"
      @notification = Notification.new
      @notification.user = @convocation.subscription.tournament.user
      @notification.convocation = @convocation
      @notification.content = "#{@convocation.subscription.user.full_name} n'est pas disponible à la date de votre convoncation"
      @notification.save
      redirect_to new_convocation_message_path(@convocation)

    elsif @convocation.status == "confirmed"
      @notification = Notification.new
      @notification.user = @convocation.subscription.tournament.user
      @notification.convocation = @convocation
      @notification.content = "#{@convocation.subscription.user.full_name} confirme sa participation le #{@convocation.date.strftime("le %d/%m/%Y")} à #{@convocation.hour.strftime(" à %Hh%M")}"
      @notification.save
      redirect_to mes_tournois_path
    else
      redirect_to mes_tournois_path
    end
  end

  def multiple_new
    @tournament       = Tournament.find(params[:tournament_id])
    @subscription_ids = params[:select_players].split(',') # ["27", "38", "37", "35"]
    @subscriptions    = Subscription.where(id: @subscription_ids) # array of subscriptions

    custom_authorize ConvocationMultiPolicy, @subscriptions

    if @subscriptions.blank?
      flash[:alert] = "Vous n'avez sélectionné aucun joueur"
      redirect_to tournament_subscriptions_path(@tournament)
    # @tournament = Tournament.find(params[:tournament_id])
    # @subscription_ids_string = params[:subscription_ids]
    else
      @player_names = @subscriptions.map { |subscription| subscription.user.full_name }
    end
  end
  # coder un système d'alert box si les dispos d'un joueur ne matchent pas avec la convoc
  def multiple_create
    @tournament = Tournament.find(params[:tournament_id])
    @subscription_ids = params[:subscription_ids].split
    @subscriptions = Subscription.where(id: @subscription_ids)
    custom_authorize ConvocationMultiPolicy, @subscriptions
    @subscriptions.each do |subscription|

      convocation = Convocation.new(date: params[:date], hour: params[:hour], subscription: subscription)

      if convocation.save && convocation.subscription.user.telephone
        @notification = Notification.new
        @notification.user = subscription.user
        @notification.convocation = convocation
        @notification.content = "Vous êtes convoqué à #{convocation.subscription.tournament.name} le #{convocation.date.strftime("%d/%m/%Y")} à #{convocation.hour.strftime(" à %Hh%M")}"
        @notification.save

        begin
          client = Twilio::REST::Client.new(ENV['sid'], ENV['token'])

          # Create and send an SMS message
          client.account.sms.messages.create(
            from: ENV['from'],
            to: convocation.subscription.user.telephone,
            body: "Vous etes convoque  #{convocation.date.strftime("le %d/%m/%Y")} #{convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{convocation.subscription.tournament.name} "
          )
        rescue Twilio::REST::RequestError
          # on error, sms won't be sent.. deal
        end
        if @subscriptions.count == 1
         flash[:notice] = "Votre convocation a bien été envoyée"
        else
          flash[:notice] = "Vos convocations ont bien été envoyées"
        end
      elsif convocation.save
         @notification = Notification.new
         @notification.user = subscription.user
         @notification.convocation = convocation
         @notification.content = "Vous êtes convoqué à #{@convocation.subscription.tournament.name} le #{@convocation.date.strftime("%d/%m/%Y")} à #{@convocation.hour.strftime(" à %Hh%M")}"
         @notification.save
        if @subscriptions.count == 1
         flash[:notice] = "Votre convocation a bien été envoyée"
        else
          flash[:notice] = "Vos convocations ont bien été envoyées"
        end
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
      params.permit(:hour, :date, :utf8, :commit, :authenticity_token, :subscription_id)
      # params.require(:convocation).permit(:hour, :date)
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


