class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show]

  def create
   @challenge = Challenge.create(challenge_params)
   @notification = Notification.create(
        user:         @challenge.contestants.last.user,
        content:      "#{@challenge.contestants.first.user.full_name} vous challenge"
      )
   authorize @challenge
   redirect_to challenge_path(@challenge)
  end

  def show
    authorize @challenge
  end

 private


  def challenge_params
    params.require(:challenge).permit(
      :time,
      :date,
      :place,
      :score,
      :referee,
      contestants_attributes: [:user_id]
      )
  end

  def set_challenge
     @challenge = Challenge.find(params[:id])
  end


end
