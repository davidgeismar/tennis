class PlayerInvitationPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user && user.judge == true
  end
end