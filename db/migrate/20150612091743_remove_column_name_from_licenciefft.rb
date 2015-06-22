class RemoveColumnNameFromLicenciefft < ActiveRecord::Migration
  def change
    remove_column :licencieffts, :first_name
    remove_column :licencieffts, :last_name
  end
end
