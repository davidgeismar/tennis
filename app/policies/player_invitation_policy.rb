class PlayerInvitationPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user && user.judge? && (record.tournament.user == user)
  end
end
