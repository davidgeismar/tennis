class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
  true
  end

  def create?
    user == record.convocation.subscription.user
  end

  def edit?
    false
  end

  def update?
    false
  end
end
