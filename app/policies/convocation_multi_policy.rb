class ConvocationMultiPolicy < ApplicationPolicy
  def multiple_new?
    multiple_create?
  end

  def multiple_create?
    user && subscriptions.all? { |subscription| subscription.tournament.user == user }
  end

  private

  def subscriptions
    return record
  end
end
