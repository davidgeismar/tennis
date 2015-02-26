class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.save
  end

  def update
    if this
      redirect_to root_path
    else
      super
    end
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

  # this is called when accepting invitation
  # should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    ## Report accepting invitation to analytics
    Analytics.report('invite.accept', resource.id)
    resource
  end
end