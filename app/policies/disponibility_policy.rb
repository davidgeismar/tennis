class DisponibilityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user && record.tournament.user == user
  end

  def create? #pas besoin de préciser pour new et edit
    (user && (record.user == user)) || (user && (record.tournament.user == user))
  end

  def edit?
    user && record.tournament.user == user
  end

  def update?
    user && record.tournament.user == user
  end
end
