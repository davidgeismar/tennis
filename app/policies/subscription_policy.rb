class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def accept_player?
    user && user == record.tournament.user
  end

  def refus_without_remboursement?
    user && user = record.tournament.user
  end

  def refund?
    user && user == record.tournament.user
  end

  def show?
    record.user == user || record.tournament.user == user
  end

  def create?
    user
  end

  def index?
   true
  end

  def update?
    record.tournament.user == user
  end
end
