class DisponibilityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new
    user && record.subscription.user == user
  end

end