class RankingsController < ApplicationController


  def show
    @competition    = Competition.find(params[:competition_id])
    @subscriptions  = @competition.subscriptions.joins(:user)

    custom_authorize(RankingPolicy, @competition)
  end
end
