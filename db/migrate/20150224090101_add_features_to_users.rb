class AddFeaturesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :ranking, :string
    add_column :users, :judge, :boolean
    add_column :users, :genre, :string
    add_column :users, :date_of_birth, :date
  end
end
