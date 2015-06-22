class ChangeDateofBirthTypeInLicenciefft < ActiveRecord::Migration
  def change
    change_column :licencieffts, :date_of_birth,  :date
  end
end
