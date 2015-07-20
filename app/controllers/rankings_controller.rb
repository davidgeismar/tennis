class RankingsController < ApplicationController
   skip_after_action :verify_authorized, only: [:datatreat]

  def show
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions.joins(:user)

    custom_authorize(RankingPolicy, @tournament)
  end
end