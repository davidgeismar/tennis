class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true # TRUCS A REVOIR
  end

  def create?
    true # TRUCS A REVOIR
  end
end
