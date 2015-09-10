class AEIExportPolicy < ApplicationPolicy
  def create?
    user && record.tournament.user == user
  end
end