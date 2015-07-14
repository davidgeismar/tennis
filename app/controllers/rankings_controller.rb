class RankingsController < ApplicationController

  def show
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions.joins(:user)

    custom_authorize(RankingPolicy, @tournament)
  end
end