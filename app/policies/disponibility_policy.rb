class DisponibilityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user && record.subscription.tournament.user == user
  end

  def create? #pas besoin de préciser pour new et edit
    user && record.subscription.user == user
  end

  def update?
    user && record.subscription.user == user
  end
end