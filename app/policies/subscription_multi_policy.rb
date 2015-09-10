class SubscriptionMultiPolicy < ApplicationPolicy
  def index?
    user && subscriptions.all? { |subscription| subscription.tournament.user == user }
  end

  private

  def subscriptions
    return record
  end
end
