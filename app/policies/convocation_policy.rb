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
    user && record.subscription.competition.tournament.user == user
  end

  def update?
    user && record.subscription.competition.tournament.user == user
  end
end
