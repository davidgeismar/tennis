class ConvocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
   user && user.judge? && (record.subscription.tournament.user == user)
  end

  def create?
   user && user.judge? && (record.subscription.tournament.user == user)
  end

  def edit?
    (user && record.subscription.tournament.user == user) ||
    (user && record.subscription.user == user)
  end

  def update?
    (user && record.subscription.tournament.user == user) ||
    (user && record.subscription.user == user)
  end
end
