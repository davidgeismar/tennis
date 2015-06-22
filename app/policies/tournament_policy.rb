class TournamentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.where(accepted: true)
    end
  end

  def new?
    user && user.judge == true
  end

  def index?
   user
  end

  def invite_player?
    user && user.judge == true
  end

  def registrate_card?
    user
  end

  def invite_player_to_tournament?
    user && user.judge == true
  end

  def AEIexport?
    user && record.user == user
  end

  def show?
    user && record.accepted? || record.user == user
  end

  def create?
    user && user.judge?
  end

  def update?
    user && record.user == user
  end

  def find?
    true
  end

  def registrate_card?
    true
  end
end
