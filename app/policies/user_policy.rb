class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit
    true
  end

  def show
     user == record || record.tournaments.any? { |t| t.user == user }

  end

  def update?
    # user == record
    true
  end

  def update_card?
    true
  end
  def set_user?
  true
  end
end
