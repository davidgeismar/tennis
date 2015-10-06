class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def accept?
    user && (user == record.competition.tournament.user)
  end

  def refus_without_remboursement?
    user && (user == record.competition.tournament.user)
  end

  def refund?
    user && (user == record.competition.tournament.user)
  end

  def refuse?
    refus_without_remboursement?
  end

  def show?
    record.user == user || record.competition.tournament.user == user
  end

  def create?
    user
  end

  def update?
    record.competition.tournament.user == user
  end
end
