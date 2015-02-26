class SubscriptionsController < ApplicationController

  def index
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    policy_scope(@subscriptions)
  end

  def update
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.update(subscription_params)
    redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  def create
    tournament    = Tournament.find(params[:tournament_id])
    @subscription = Subscription.new
    authorize @subscription

    @subscription.tournament = tournament
    @subscription.user = current_user
    @subscription.save

    redirect_to tournament_subscription_path(tournament, @subscription)
  end

  private

  def subscription_params
    params.require(:subscription).permit(:status)
  end

end
