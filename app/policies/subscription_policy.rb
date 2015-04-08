class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.user == user || record.tournament.user == user
  end

  def create?
    user
  end

  def index?
    record.tournament.user == user
  end

  def update?
    record.tournament.user == user
  end
end
