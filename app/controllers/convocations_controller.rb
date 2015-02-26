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



  private

  def convocation_params
    params.require(:convocation).permit(:hour, :date)
  end

  def find_subscription
    @subscription = Subscription.find(params[:subscription_id])
  end

end
