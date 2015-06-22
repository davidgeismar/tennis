class AddColumnFullnameToLicenciefft < ActiveRecord::Migration
  def change
    add_column :licencieffts, :full_name, :string
  end
end
