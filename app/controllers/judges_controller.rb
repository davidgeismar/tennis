class JudgesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def show
    @user = User.new(judge: true)
  end
end