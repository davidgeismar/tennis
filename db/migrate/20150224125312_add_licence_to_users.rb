class AddLicenceToUsers < ActiveRecord::Migration
  def change
     add_column :users, :licence_number, :string
  end
end
