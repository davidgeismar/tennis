class CompetitionMultiPolicy < ApplicationPolicy
  def multiple_new?
    multiple_create?
  end

  def multiple_create?
    user && !user.judge?
  end

  private

  def subscriptions
    return record
  end
end
