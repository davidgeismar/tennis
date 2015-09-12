class ConvocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
   user && user.judge?
  end

  def create?
   user && user.judge?
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
