class ChallengesController < ApplicationController
  def new
    @challenge = Challenge.new
    authorize @challenge
  end
  def create
    @challenge = Challenge.new(challenge_params)
    if @challenge.save
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(
      :place,
      :date,
      :time,
      :score,
      :winner,
      :loser,
      :referee
      )
  end
end
