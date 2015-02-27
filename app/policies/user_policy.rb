class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show
    user == record || record.tournaments.any? { |t| t.user == user }
  end

  def update?
    user == record
  end
end
