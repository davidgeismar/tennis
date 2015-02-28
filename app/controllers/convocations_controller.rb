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
    redirect_to user_path(current_user)
  end

  def multiple_new
    @tournament = Tournament.find(params[:tournament_id])
    @subscription_ids_string = params[:subscription_ids]
    @subscription_ids = params[:subscription_ids].split(', ')
    @player_names = []
    @subscription_ids.each do |subscription_id|
      @player_names << Subscription.find(subscription_id).user.name
    end
  end

  def multiple_create
    @tournament = Tournament.find(params[:tournament_id])
    @subscription_ids = params[:subscription_ids].split(', ')
    @subscription_ids.each do |subscription_id|
      @subscription = Subscription.find(subscription_id)
      Convocation.create(date: params[:date], hour: params[:hour], subscription: @subscription)
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
    params.require(:convocation).permit(:hour, :date, :status)
  end

  def find_subscription
    if params[:subscription_id] != nil
      @subscription = Subscription.find(params[:subscription_id])
    else
      @convocation = Convocation.find(params[:id])
    end

  end

end
