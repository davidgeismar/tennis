class SubscriptionsController < ApplicationController
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
end
