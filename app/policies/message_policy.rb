class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user && user == record.convocation.subscription.user
  end

  def create?
    user &&  user == record.convocation.subscription.user
  end

  def edit?
    false
  end

  def update?
    false
  end
end
