class TournamentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      .where(accepted: true)
      .where("ends_on >= :today", today: Date.today)
    end
  end

  def new?
    user && user.judge == true
  end

  def index?
    true
  end

  def show?
   record.accepted? || record.user == user
  end

  def destroy?
    user && (record.user == user)
  end

  def create?
    user && user.judge?
  end

  def passed?
    user && user.judge?
  end

  def update?
    user && record.user == user
  end

  def passed_tournaments?
    user
  end
end
