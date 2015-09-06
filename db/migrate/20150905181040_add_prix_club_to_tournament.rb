class AddPrixClubToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :club_fare, :integer
  end
end
