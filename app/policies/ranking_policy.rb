class RankingPolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end