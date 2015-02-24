class AddClubOrganisateurToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :club_organisateur, :string
  end
end
