class AddDetailsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :address, :string
  end
end
