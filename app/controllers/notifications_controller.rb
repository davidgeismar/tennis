class NotificationsController < ApplicationController

  def index
    @activities = PublicActivity::Activity.all
    # @activities = policy_scope(PublicActivity::Activity)
    authorize@activities
  end

end
