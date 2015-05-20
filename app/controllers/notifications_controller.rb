class NotificationsController < ApplicationController
  skip_after_action :verify_authorized

  def update
    current_user.notifications.each do |notification|
      notification.read == true
      notification.save
    end
    render nothing: true
  end

end