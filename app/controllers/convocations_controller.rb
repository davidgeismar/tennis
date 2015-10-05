class ConvocationsController < ApplicationController
  before_action :find_subscription, except: [:multiple_new, :multiple_create]
  before_action :set_competition, only: [:multiple_new, :multiple_create]

  def new
    @convocation              = Convocation.new
    @convocation.subscription = @subscription
    authorize @convocation
  end
  # attention coder le sms system pour create
  def create
    @convocation  = @subscription.convocations.build(convocation_params)
    judge         = @subscription.tournament.user

    authorize @convocation

    if @convocation.save
      ConvocationMailer.send_convocation(@convocation).deliver

      if @convocation.subscription.user.telephone && judge.sms_forfait && judge.sms_quantity > 0
        TextMessages::Convocations::CreateTextMessageService.new(@convocation).new_proposition
      end

      @notification = Notification.create(
        user:     @convocation.subscription.user,
        content:  "Le juge-arbitre vous propose une nouvelle convocation #{@convocation.date.strftime("le %d/%m/%Y")} #{@convocation.hour.strftime(" à %Hh%M")} pour le tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}",
        convocation: @convocation
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
    judge = @convocation.subscription.tournament.user

    if @convocation.status == "refused"
      @notification = Notification.create(
        user:         @convocation.subscription.tournament.user,
        convocation:  @convocation,
        content:      "#{@convocation.subscription.user.full_name} n'est pas disponible #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %Hh%M")} pour #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category}"
      )
      if @convocation.message
        redirect_to mytournaments_path
      else
        redirect_to new_convocation_message_path(@convocation)
      end
    elsif @convocation.status == "confirmed"
      #email
      ConvocationMailer.convocation_confirmed_by_player(@convocation).deliver
      #notif
      @notification = Notification.create(
        user:         @convocation.subscription.tournament.user,
        convocation:  @convocation,
        content:      "#{@convocation.subscription.user.full_name} confirme sa participation #{@convocation.date.strftime("le %d/%m/%Y")}#{@convocation.hour.strftime(" à %Hh%M")} dans la catégorie #{@convocation.subscription.competition.category}"
      )

      flash[:notice] = "Le statut de cette convocation est à présent : CONFIRMÉ"
      redirect_to mytournaments_path

    elsif @convocation.status == "confirmed_by_judge"
      #email
      ConvocationMailer.convocation_confirmed_by_judge(@convocation).deliver
      #notif
      @notification = Notification.create(
        user:         @convocation.subscription.user,
        convocation:  @convocation,
        content:      "Le juge arbitre de #{@convocation.tournament.name} ne peut pas vous proposer un autre créneau pour votre convocation"
      )

      # sms
      if @convocation.subscription.user.telephone && judge.sms_forfait && judge.sms_quantity > 0
        TextMessages::Convocations::CreateTextMessageService.new(@convocation).call
      end

      flash[:notice] = "La convocation a bien été confirmée"
      redirect_to competition_subscriptions_path(@convocation.subscription.competition)
    else
      flash[:alert] = "Vous venez d'indiquer au juge arbitre que vous abandonnez la compétition"
      redirect_to mytournaments_path
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
          TextMessages::Convocations::CreateTextMessageService.new(convocation).call
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
