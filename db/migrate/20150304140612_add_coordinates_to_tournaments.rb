class AddCoordinatesToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :latitude, :float
    add_column :tournaments, :longitude, :float
  end
end
