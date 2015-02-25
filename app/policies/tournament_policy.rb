class TournamentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.where(accepted: true)
    end
  end

  def index?
   true
  end

  def show?
    user && record.accepted? || record.user == user
  end

  def create?
    user && user.judge?
  end

  def update?
    user && user.judge?
  end
end
