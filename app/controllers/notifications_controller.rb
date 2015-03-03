class NotificationsController < ApplicationController
  def index
    @activities = PublicActivity::Activity.where(recipient: current_user)
  end
end
