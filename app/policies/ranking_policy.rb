class RankingPolicy < ApplicationPolicy
  def show?
    record.tournament.user == user
  end
end