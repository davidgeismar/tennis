class AEIExportPolicy < ApplicationPolicy
  def create?
    user && record.user == user
  end
end