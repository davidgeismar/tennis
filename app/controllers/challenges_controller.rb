class ChallengesController < ApplicationController

  def create
    Challenge.create(challenge_params)
  end

  def private


  def challenge_params
    params.require(:challenge).permit(
      :time,
      :date,
      :place,
      :score,
      :referee
      )
  end


end
