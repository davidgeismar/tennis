class MytournamentsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    if current_user.judge?
      @current_tournaments  = current_user.tournaments.current
      @passed_tournaments   = current_user.tournaments.passed
    else
      @subscriptions        = current_user.subscriptions.current

      if @subscriptions.blank?
        flash[:notice] = "Vous ne vous êtes pas encore inscrit à un tournoi."
      end
    end
  end

  def passed
    @passed_tournaments = current_user.tournaments.passed
    authorize @passed_tournaments
  end
end
