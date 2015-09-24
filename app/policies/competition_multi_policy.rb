class CompetitionMultiPolicy < ApplicationPolicy
  def multiple_new?
    true
  end

  def multiple_create?
    true
  end

  private

  def subscriptions
    return record
  end
end
