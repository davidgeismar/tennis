class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit
    user == record
  end

  def show?
     user == record || record.tournaments.any? { |t| t.user == user }
  end

  def update?
    user == record
  end

  def update_card?
   user == record
  end

  def set_user?
  true
  end
end
