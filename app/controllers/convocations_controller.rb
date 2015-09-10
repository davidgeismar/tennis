class ConvocationsController < ApplicationController
  before_action :find_subscription, except: [:multiple_new, :multiple_create]
  before_action :set_competition, only: [:multiple_new, :multiple_create]

  def new
    @convocation = Convocation.new
    authorize @convocation
  end
  # attention coder le sms system pour create
  def create
    @convocation = @subscription.convocations.build(convocation_params)
    authorize @convocation

    if @convocation.save
      ConvocationMailer.send_convocation(@convocation).deliver

      @notification = Notification.create(
        user:     @convocation.subscription.user,
        content:  "Vous êtes convoqué(e) à #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category} #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %Hh%M")}"
      )
      flash[:notice] = "Votre convocation a bien été envoyée"
      redirect_to competition_subscriptions_path(@subscription.competition)
    else
      render :new
    end
  end

  def edit
    authorize @convocation
  end

  def update
    authorize @convocation
    @convocation.update(convocation_params)

    if @convocation.status == "refused"
      @notification = Notification.create(
        user:         @convocation.subscription.tournament.user,
        convocation:  @convocation,
        content:      "#{@convocation.subscription.user.full_name} n'est pas disponible #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %Hh%M")} pour #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}"
      )

      redirect_to new_convocation_message_path(@convocation)
    elsif @convocation.status == "confirmed" && current_user.judge?
      @notification = Notification.create(
        user:         @convocation.subscription.user,
        convocation:  @convocation,
        content:      "#{@convocation.subscription.tournament.user.full_name}, juge-arbitre de #{@convocation.subscription.tournament.name}, ne peut pas vous proposer une autre date/horaire, il vous demande donc d'être présent le #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %H%M")}"
      )
      flash[:notice] = "Le statut de cette convocation est à présent : CONFIRMÉ"
      redirect_to
    elsif @convocation.status == "confirmed"
      @notification = Notification.create(
        user:         @convocation.subscription.tournament.user,
        convocation:  @convocation,
        content:      "#{@convocation.subscription.user.full_name} confirme sa participation #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %Hh%M")} dans la catégorie #{@convocation.subscription.competition.category}"
      )

      flash[:notice] = "Le statut de cette convocation est à présent : CONFIRMÉ"
      redirect_to competition_subscriptions_path(@convocation.subscription.competition)
    else
      flash[:alert] = "Vous venez d'indiquer au juge arbitre que vous abandonnez la compétition"
      redirect_to mes_tournois_path
    end
  end

  def multiple_new
    @subscription_ids = params[:select_players].split(',') # ["27", "38", "37", "35"]
    @subscriptions    = Subscription.where(id: @subscription_ids) # array of subscriptions

    custom_authorize ConvocationMultiPolicy, @subscriptions

    if @subscriptions.blank?
      flash[:alert] = "Vous n'avez sélectionné aucun joueur"
      redirect_to competition_subscriptions_path(@competition)
    else
      @player_names = @subscriptions.map { |subscription| subscription.user.full_name }
    end
  end

  # coder un système d'alert box si les dispos d'un joueur ne matchent pas avec la convoc
  def multiple_create
    # @tournament = Tournament.find(params[:tournament_id])
    judge             = @competition.tournament.user
    @subscription_ids = params[:subscription_ids].split
    @subscriptions    = Subscription.where(id: @subscription_ids)
    @player_names     = @subscriptions.map { |subscription| subscription.user.full_name }
    custom_authorize ConvocationMultiPolicy, @subscriptions

    if params[:date].blank? || params[:hour].blank?
      flash[:alert] = "Merci de compléter à la fois la date et l'heure de convocation."
      return render :multiple_new
    end

    @subscriptions.each do |subscription|
      convocation = Convocation.new(date: params[:date], hour: params[:hour], subscription: subscription)

      if convocation.save
        ConvocationMailer.send_convocation(convocation).deliver

        @notification = Notification.create(
          user:         subscription.user,
          convocation:  convocation,
          content:      "Vous êtes convoqué(e) à #{convocation.subscription.tournament.name} dans la catégorie #{convocation.subscription.competition.category} le #{convocation.date.strftime("%d/%m/%Y")}#{convocation.hour.strftime(" à %Hh%M")}"
        )

        if @subscriptions.count == 1
         flash[:notice] = "Votre convocation a bien été envoyée"
        else
          flash[:notice] = "Vos convocations ont bien été envoyées"
        end

        if convocation.subscription.user.telephone && judge.sms_forfait && judge.sms_quantity > 0
          begin
            client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])

            # Create and send an SMS message
            client.account.sms.messages.create(
              from: ENV['TWILIO_FROM'],
              to:   convocation.subscription.user.telephone,
              body: "Vous etes convoqué(e) #{convocation.date.strftime("le %d/%m/%Y")} #{convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{convocation.subscription.tournament.name} "
            )
            sms_credit = judge.sms_quantity - 1
            judge.sms_quantity = sms_credit
            judge.save
          rescue Twilio::REST::RequestError
            # on error, sms won't be sent.. deal
          end
        end
      else
        flash[:warning] = "Un problème est survenu veuillez réessayer d'envoyer votre convocation"
      end
    end

    redirect_to competition_subscriptions_path(@competition)
  end

  private

  def convocation_params
    if current_user.judge?
      params.require(:convocation).permit(:hour, :date, :status)
    else
      params.require(:convocation).permit(:status)
    end
  end

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end

  def find_subscription
    if params[:subscription_id] != nil
      @subscription = Subscription.find(params[:subscription_id])
    else
      @convocation = Convocation.find(params[:id])
    end
  end
end
