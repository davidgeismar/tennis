class NotificationsController < ApplicationController

  def index
    @activities = PublicActivity::Activity.where(recipient: current_user)
    @activities = policy_scope(PublicActivity::Activity)
  end

end
