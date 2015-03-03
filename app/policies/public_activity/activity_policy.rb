class PublicActivity::ActivityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient: user)
    end
  end

  def index?
    true
  end
end
