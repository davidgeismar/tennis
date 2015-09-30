class AEIExportPolicy < ApplicationPolicy
  def create?
    user && record.tournament.user == user
  end
  def export_disponibilities?
    user && record.tournament.user == user
  end
end
