class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.save
  end

  private

  # this is called when creating invitation
  # should return an instance of resource class
  def invite_resource
    ## skip sending emails on invite
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.skip_invitation = true
    end
  end
end