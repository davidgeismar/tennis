class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user && (record.convocation.subscription.user == user)
  end

  def create?
    user && (record.convocation.subscription.user == user)
  end

  def show?
    user && (record.convocation.subscription.tournament.user == user)
  end
end
