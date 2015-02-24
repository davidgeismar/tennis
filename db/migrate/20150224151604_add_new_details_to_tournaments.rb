class AddNewDetailsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :city, :string
    add_column :tournaments, :name, :string
  end
end
