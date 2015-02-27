class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show
    true #a revoir
  end
  def update?
    user == record
  end
end
