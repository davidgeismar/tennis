class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true # TRUCS A REVOIR
  end

  def create?
    true # TRUCS A REVOIR
  end

  def index?
    true
  end

  def update?
    true
  end
end
