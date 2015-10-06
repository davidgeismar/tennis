class CompetitionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user && user.judge? && (record.tournament.user == user)
  end

  def show?
    user && (record.tournament.user == user)
  end

  def create? #pas besoin de préciser pour new et edit
    user && record.tournament.user == user
  end

  def update?
    user && record.tournament.user == user
  end

  def index?
    user && (user.judge == false)
  end

  def update_rankings?
    user && record.tournament.user == user
  end

  def edit?
    user && record.tournament.user == user
  end

  def export_disponibilities?
    user && record.tournament.user == user
  end
end
