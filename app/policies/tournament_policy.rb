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
   user
  end

  def show?
    user && record.accepted? || record.user == user
  end

  def create?
    user && user.judge?
  end

  def update?
    user && record.user == user
  end

  def update_rankings?
    user && record.user == user
  end

  def find?
    true
  end
end
