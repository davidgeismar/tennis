class AddColumnAddressAndBicToUser < ActiveRecord::Migration
  def change
    add_column :users, :bic, :string
    add_column :users, :address, :string
  end
end
