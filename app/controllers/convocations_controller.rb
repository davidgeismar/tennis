class ConvocationsController < ApplicationController
  before_action :find_subscription

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
    redirect_to user_path
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
